enum StateStatus { initial, loading, success, failure }

extension StateStatusX on StateStatus {
    bool get isInitial => this == StateStatus.initial;
    bool get isLoading => this == StateStatus.loading;
    bool get isSuccess => this == StateStatus.success;
    bool get isFailure => this == StateStatus.failure;

    String get serialize => name;
}

extension StateStatusString on String {
    /// Parses a persisted status. Unknown values fall back to [StateStatus.initial]
    /// instead of throwing, so an odd value can't wipe the saved state.
    StateStatus get toStateStatus => StateStatus.values.firstWhere(
        (status) => status.name == toLowerCase(),
        orElse: () => StateStatus.initial,
    );
}
