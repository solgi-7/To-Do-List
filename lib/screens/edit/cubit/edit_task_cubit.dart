import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_task/data/data_entity.dart';
import 'package:to_do_task/data/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EditTaskCubit(this._task, this.repository) : super(EditTaskInitial(_task));

  void onSaveChangesClick (){ 
    repository.createOrUpdate(_task);
  }

  void onTextChanged (String text){
    _task.name = text ;
  }
  void onPriorityCheanged (Priority priority){
    _task.priority = priority;
    emit(EditTaskPriority(_task));
  }
}
