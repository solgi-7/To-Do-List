import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_task/data/data_entity.dart';
import 'package:to_do_task/data/repo/repository.dart';
part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>(
      (event, emit) async {
        if (event is TaskListStarted || event is TaskListSearch) {
          final String searchTerm;
          emit(TaskListLoading());
          if (event is TaskListSearch) {
            searchTerm = event.searchTerm;
          } else {
            searchTerm = '';
          }
          try {
            final items = await repository.getAll(searchKeyword: searchTerm);
            if (items.isNotEmpty) {
              emit(TaskListSuccess(items));
            } else {
              emit(TaskListEmpty());
            }
          } catch (e) {
            emit(TaskListError("خطای نامشخصی اتفاق افتاده"));
          }
        } else if (event is TaskListDeleteAll) {
          await repository.deleteAll();
          emit(TaskListEmpty());
        }
      },
    );
  }
}
