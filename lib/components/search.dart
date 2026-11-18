import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/states/cities_cubit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Search field bound to [CitiesCubit]. Every keystroke is forwarded; the
/// cubit debounces and ignores queries shorter than 2 characters.
class Search extends StatefulWidget {
    final bool autofocus;

    /// Called after the field was cleared with the ✕ button.
    final VoidCallback? onCleared;

    const Search({ super.key, this.autofocus = false, this.onCleared });

    @override
    State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
    late final TextEditingController _controller;

    @override
    void initState() {
        super.initState();
        _controller = TextEditingController(text: context.read<CitiesCubit>().state.query);
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    void _clear() {
        _controller.clear();
        context.read<CitiesCubit>().clear();
        widget.onCleared?.call();
    }

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context).colorScheme;
        final cubit = context.read<CitiesCubit>();

        return DecoratedBox(
            decoration: BoxDecoration(color: theme.surfaceContainerHigh, borderRadius: BorderRadius.circular(28)),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: TextField(
                    controller: _controller,
                    autofocus: widget.autofocus,
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: cubit.queryChanged,
                    onSubmitted: cubit.search,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: context.l10n.searchHint,
                        prefixIcon: const Icon(Icons.search_outlined),
                        prefixIconColor: theme.primary,
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _controller,
                            builder: (context, value, _) => value.text.isEmpty
                                ? const SizedBox.shrink()
                                : IconButton(tooltip: context.l10n.clearSearch, onPressed: _clear, icon: const Icon(Icons.cancel)),
                        ),
                        suffixIconColor: theme.onSurfaceVariant,
                    ),
                ),
            ),
        );
    }
}
