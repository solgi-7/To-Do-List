part of 'edit_task_cubit.dart';

@immutable
abstract class EditTaskState {
  final TaskEntity task;

  const EditTaskState(this.task);
}

class EditTaskInitial extends EditTaskState {
  const EditTaskInitial(TaskEntity task) : super(task);
}

class EditTaskPriority extends EditTaskState {
  EditTaskPriority(TaskEntity task) : super(task);
}
