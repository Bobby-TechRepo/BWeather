import 'dart:async';
import 'dart:developer';

import 'package:bweather/utils/cities.dart';
import 'package:bweather/utils/status.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SortBy { name, country }

class CitiesState extends Equatable {
    /// Built-in capital cities, sorted by [sortBy].
    final List<CityData> catalog;

    /// Index in [catalog] -> letter header to show above that row.
    final Map<int, String> letters;
    final SortBy sortBy;

    final String query;
    final List<City> searchResults;
    final StateStatus status;

    const CitiesState({
        this.catalog = const [], this.letters = const {}, this.sortBy = SortBy.name,
        this.query = "", this.searchResults = const [], this.status = StateStatus.initial,
    });

    bool get isSearching => query.trim().isNotEmpty;

    CitiesState copy({ List<CityData>? catalog, Map<int, String>? letters, SortBy? sortBy, String? query, List<City>? searchResults, StateStatus? status }) {
        return CitiesState(
            catalog: catalog ?? this.catalog,
            letters: letters ?? this.letters,
            sortBy: sortBy ?? this.sortBy,
            query: query ?? this.query,
            searchResults: searchResults ?? this.searchResults,
            status: status ?? this.status,
        );
    }

    @override
    List<Object?> get props => [catalog, letters, sortBy, query, searchResults, status];
}

class CitiesCubit extends Cubit<CitiesState> {
    /// Wait for the user to stop typing before calling the API.
    static const debounce = Duration(milliseconds: 350);

    /// Open-Meteo returns nothing for 1-character queries.
    static const minQueryLength = 2;

    final ForecastRepository _repository;
    Timer? _debounceTimer;

    /// Incremented per request; responses from older requests are ignored.
    int _requestId = 0;

    CitiesCubit({ ForecastRepository? repository }): _repository = repository ?? ForecastRepository(), super(const CitiesState()) {
        _sort(SortBy.name);
    }

    set sortBy(SortBy sortBy) => _sort(sortBy);

    /// Call on every keystroke; the request is debounced.
    void queryChanged(String query) {
        _debounceTimer?.cancel();
        final trimmed = query.trim();

        if (trimmed.length < minQueryLength) {
            _requestId++;
            emit(state.copy(query: query, searchResults: const [], status: StateStatus.initial));
            return;
        }

        emit(state.copy(query: query, status: StateStatus.loading));
        _debounceTimer = Timer(debounce, () => search(trimmed));
    }

    /// Runs a search immediately (e.g. when the user presses enter).
    Future<void> search(String query) async {
        _debounceTimer?.cancel();
        final trimmed = query.trim();
        if (trimmed.length < minQueryLength) return;

        final requestId = ++_requestId;
        emit(state.copy(query: query, status: StateStatus.loading));

        try {
            final results = await _repository.search(trimmed);
            if (requestId != _requestId || isClosed) return;
            emit(state.copy(searchResults: results, status: StateStatus.success));
        } on LocationNotFoundFailure {
            if (requestId != _requestId || isClosed) return;
            // No matches is a successful search with no results (not an error).
            emit(state.copy(searchResults: const [], status: StateStatus.success));
        } catch (error) {
            log("City search error", error: error);
            if (requestId != _requestId || isClosed) return;
            emit(state.copy(searchResults: const [], status: StateStatus.failure));
        }
    }

    void clear() {
        _debounceTimer?.cancel();
        _requestId++;
        emit(state.copy(query: "", searchResults: const [], status: StateStatus.initial));
    }

    void _sort(SortBy sortBy) {
        String keyOf(CityData city) => sortBy == SortBy.name ? city.name : city.country;

        // Sort a copy: the built-in list is shared and must not be mutated.
        final catalog = [...cities]..sort((a, b) => keyOf(a).compareTo(keyOf(b)));

        final letters = <int, String>{};
        String last = "";
        for (int index = 0; index < catalog.length; index++) {
            final letter = keyOf(catalog[index]).characters.first.toUpperCase();
            if (last != letter) {
                letters[index] = letter;
                last = letter;
            }
        }
        emit(state.copy(sortBy: sortBy, catalog: catalog, letters: letters));
    }

    @override
    Future<void> close() {
        _debounceTimer?.cancel();
        return super.close();
    }
}
