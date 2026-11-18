import 'dart:developer';

/// Small helpers for reading loosely-typed JSON maps.
///
/// The `*OrNull` / `*List` helpers never throw: a missing or malformed value
/// yields `null` / an empty list, so one bad field can't take down a whole
/// persisted state.
class JsonParser {
    static int parseInt(dynamic json, String key) {
        return num.parse(json[key].toString()).toInt();
    }

    static int? parseIntOrNull(dynamic json, String key) {
        final value = json[key];
        if (value == null) return null;
        return num.tryParse(value.toString())?.toInt();
    }

    static double parseDouble(dynamic json, String key) {
        return double.parse(json[key].toString());
    }

    static double? parseDoubleOrNull(dynamic json, String key) {
        final value = json[key];
        if (value == null) return null;
        return double.tryParse(value.toString());
    }

    static String parseString(dynamic json, String key) {
        return json[key].toString();
    }

    static String? parseStringOrNull(dynamic json, String key) {
        final value = json[key];
        if (value == null) return null;
        final text = value.toString();
        return text.isEmpty || text == "null" ? null : text;
    }

    static bool parseBoolean(dynamic json, String key) {
        final value = json[key];
        if (value is bool) return value;
        if (value is num) return value != 0;
        return value.toString() == "true" || value.toString() == "1";
    }

    static DateTime parseDate(dynamic json, String key) {
        return DateTime.parse(json[key].toString());
    }

    static DateTime? parseDateOrNull(dynamic json, String key) {
        final value = json[key];
        if (value == null) return null;
        return DateTime.tryParse(value.toString());
    }

    static List<T> _parseList<T>(dynamic json, String key, T Function(Object? element) convert) {
        final value = json is Map ? json[key] : null;
        if (value == null) {
            return [];
        }
        if (value is! List) {
            log("json value for '$key' is not a List");
            return [];
        }
        try {
            return value.map(convert).toList();
        } catch (error) {
            log("json parsing error encountered for '$key'", error: error);
            return [];
        }
    }

    /// Open-Meteo returns `null` inside arrays for hours a model doesn't cover
    /// (e.g. precipitation probability far in the future); those become 0.
    static List<double> parseDoubleList(dynamic json, String key) =>
        _parseList(json, key, (element) => element == null ? 0.0 : double.parse(element.toString()));

    /// Like [parseDoubleList] but keeps gaps as `null` (for averages, where 0 would skew).
    static List<double?> parseNullableDoubleList(dynamic json, String key) =>
        _parseList(json, key, (element) => element == null ? null : double.tryParse(element.toString()));

    static List<int> parseIntList(dynamic json, String key) =>
        _parseList(json, key, (element) => element == null ? 0 : num.parse(element.toString()).toInt());

    static List<String> parseStringList(dynamic json, String key) =>
        _parseList(json, key, (element) => element.toString());

    static List<DateTime> parseDateList(dynamic json, String key) =>
        _parseList(json, key, (element) => DateTime.parse(element.toString()));
}
