import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_task/data/data_entity.dart'; 
part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) {
      
    });
  }
}
