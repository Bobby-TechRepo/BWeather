import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Top-level destinations. Which ones are visible depends on the layout
/// (desktop shows the locations list permanently beside the forecast).
enum AppTab { forecast, locations, trips, settings }

class MainState extends Equatable {
    final AppTab tab;

    /// Key of the place the forecast pager should show (null = first place).
    final String? selectedPlace;

    /// Bumped every time [selectedPlace] is requested, so selecting the same
    /// place twice still scrolls the pager back to it.
    final int selectionRequest;

    /// False while the user scrolls the Locations list down.
    final bool fabRequested;

    /// The "add city" button only shows on the Locations tab while scrolling up.
    bool get showFab => fabRequested && tab == AppTab.locations;

    const MainState({ this.tab = AppTab.forecast, this.selectedPlace, this.selectionRequest = 0, this.fabRequested = true });

    MainState copy({ AppTab? tab, String? selectedPlace, int? selectionRequest, bool? fabRequested }) {
        return MainState(
            tab: tab ?? this.tab,
            selectedPlace: selectedPlace ?? this.selectedPlace,
            selectionRequest: selectionRequest ?? this.selectionRequest,
            fabRequested: fabRequested ?? this.fabRequested,
        );
    }

    @override
    List<Object?> get props => [tab, selectedPlace, selectionRequest, fabRequested];
}

class MainCubit extends Cubit<MainState> {
    MainCubit(): super(const MainState());

    set tab(AppTab tab) => emit(state.copy(tab: tab, fabRequested: true));

    /// Switches to the forecast tab and pages to the place with [key].
    void showPlace(String key) {
        emit(state.copy(tab: AppTab.forecast, selectedPlace: key, selectionRequest: state.selectionRequest + 1));
    }

    /// Records the page the user swiped to (does not trigger a jump).
    void placeVisible(String key) {
        if (state.selectedPlace != key) {
            emit(state.copy(selectedPlace: key));
        }
    }

    set showFab(bool value) {
        if (state.fabRequested != value) {
            emit(state.copy(fabRequested: value));
        }
    }
}
