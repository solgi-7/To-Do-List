part of 'task_list_bloc.dart';

@immutable
abstract class TaskListState {}

class TaskListInitial extends TaskListState {}
class TaskListLoading extends TaskListState {}
class TaskListEmpty extends TaskListState {}
class TaskListError extends TaskListState {
  final String errorMsg;
  TaskListError(this.errorMsg);
}
class TaskListSuccess extends TaskListState {
  final List<TaskEntity> items;
  TaskListSuccess(this.items);
}
 