import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stover/shared/components/components.dart';
import 'package:stover/shared/cubit/cubit.dart';
import 'package:stover/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
 // const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).archivedTasks;

        return tasksBulider(
          tasks: tasks,
        );
      },

    );
  }
}
