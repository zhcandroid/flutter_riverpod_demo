/// 通用API响应模型
class ApiResponse<T> {
  final int statusCode;
  final String? message;
  final T? data;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.statusCode,
    this.message,
    this.data,
    this.meta,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return ApiResponse(
      statusCode: json['status'] ?? 200,
      message: json['message'],
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      meta: json['meta'],
    );
  }

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get hasData => data != null;
}

/// 分页数据模型
class PaginatedData<T> {
  final List<T> items;
  final int currentPage;// 当前页码
  final int totalPages;// 总页数
  final int totalItems;// 总条目数
  final int perPage;// 每页条目数

  PaginatedData({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
  });

  bool get hasMore => currentPage < totalPages;
}

