import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'to_do_list_widget2.g.dart';

// 1. Todo数据模型
class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Todo({required this.userId, required this.id, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}

// 2. 分页Provider
//flutter pub run build_runner build
@riverpod
class TodoListNotifier extends _$TodoListNotifier{
  int _page = 1;
  bool _hasMore = true;
  final int _pageSize = 20;
  List<Todo> _todos = [];

  @override
  Future<List<Todo>> build() async {
    _page = 1;
    _hasMore = true;
    _todos = [];
    return await _fetchTodos(reset: true);
  }

  Future<List<Todo>> _fetchTodos({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _todos = [];
    }
    if (!_hasMore) return _todos;
    final response = await Dio().get(
      'https://jsonplaceholder.typicode.com/todos',
      queryParameters: {
        '_page': _page,
        '_limit': _pageSize,
      },
    );

    final List<Todo> newTodos = response.data is List
        ? (response.data as List).map((item) => Todo.fromJson(item)).toList()
        : [];

    // final List<Todo> newTodos = List<Todo>.from(response.data);
    if (newTodos.length < _pageSize) {
      _hasMore = false;
    }
    if (reset) {
      _todos = newTodos;
    } else {
      _todos.addAll(newTodos);
    }
    return _todos;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchTodos(reset: true));
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    _page++;
    state = AsyncValue.data(await _fetchTodos());
  }
}
// final todoListProvider =
// AutoDisposeAsyncNotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);


// 3. 列表UI，支持下拉刷新和上拉加载更多
class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListAsync = ref.watch(todoListNotifierProvider);//todoListNotifierProvider
    final notifier = ref.read(todoListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo 列表')),
      body: todoListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('加载失败: $e')),
        data: (todos) => RefreshIndicator(
          onRefresh: () => notifier.refresh(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100 &&
                  scrollInfo is ScrollUpdateNotification) {
                notifier.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Icon(
                    todo.completed == true ? Icons.check_box : Icons.check_box_outline_blank,
                    color: todo.completed == true ? Colors.green : null,
                  ),
                  title: Text(todo.title ?? ''),
                  subtitle: Text('ID: ${todo.id}'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
