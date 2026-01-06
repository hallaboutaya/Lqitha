/// Paginated result model
/// 
/// Represents a paginated list of items with metadata about pagination.
library;

class PaginatedResult<T> {
  /// List of items in the current page
  final List<T> items;
  
  /// Total number of items across all pages
  final int total;
  
  /// Current page number (1-indexed)
  final int page;
  
  /// Number of items per page
  final int pageSize;
  
  /// Whether there are more items available
  final bool hasMore;
  
  /// Total number of pages
  final int totalPages;
  
  PaginatedResult({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  })  : hasMore = (page * pageSize) < total,
        totalPages = (total / pageSize).ceil();
  
  /// Create an empty paginated result
  factory PaginatedResult.empty({
    int page = 1,
    int pageSize = 20,
  }) {
    return PaginatedResult<T>(
      items: [],
      total: 0,
      page: page,
      pageSize: pageSize,
    );
  }
  
  /// Create a paginated result from a full list
  factory PaginatedResult.fromList(
    List<T> allItems, {
    int page = 1,
    int pageSize = 20,
  }) {
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    final items = allItems.length > startIndex
        ? allItems.sublist(
            startIndex,
            endIndex > allItems.length ? allItems.length : endIndex,
          )
        : <T>[];
    
    return PaginatedResult<T>(
      items: items,
      total: allItems.length,
      page: page,
      pageSize: pageSize,
    );
  }
  
  /// Get the next page number
  int? get nextPage => hasMore ? page + 1 : null;
  
  /// Get the previous page number
  int? get previousPage => page > 1 ? page - 1 : null;
  
  @override
  String toString() {
    return 'PaginatedResult(items: ${items.length}, total: $total, page: $page/$totalPages, hasMore: $hasMore)';
  }
}

