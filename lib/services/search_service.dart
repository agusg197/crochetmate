class SearchService {
  static List<T> searchItems<T>({
    required List<T> items,
    required String query,
    required String Function(T) getSearchableText,
  }) {
    if (query.isEmpty) return items;

    final lowercaseQuery = query.toLowerCase();
    return items.where((item) {
      final searchableText = getSearchableText(item).toLowerCase();
      return searchableText.contains(lowercaseQuery);
    }).toList();
  }
}
