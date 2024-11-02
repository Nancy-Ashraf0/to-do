import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/ui/providers/list_provider.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/ui/screens/home/tabs/todo_list/todo.dart';

import '../../../../../utils/app_colors.dart';

class TodoList extends StatefulWidget {
  TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late ListProvider provider;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getTodosFromFireStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    themeProvider = Provider.of(context);
    return Column(
      children: [
        Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                buildCalenderBg(),
                buildCalender(),
              ],
            )),
        Expanded(
            flex: 7,
            child: ListView.builder(
                itemCount: provider.todos.length,
                itemBuilder: (context, index) {
                  return Todo(item: provider.todos[index]);
                }))
      ],
    );
  }

  Column buildCalenderBg() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: AppColors.primary,
          ),
        ),
        Expanded(
            child: Container(
          color: Colors.transparent,
        ))
      ],
    );
  }

  EasyDateTimeLine buildCalender() {
    return EasyDateTimeLine(
      initialDate: provider.selectedDate,
      headerProps: const EasyHeaderProps(showHeader: false),
      activeColor: AppColors.primary,
      onDateChange: (newDate) {
        provider.selectedDate = newDate;
        //print("selected=${provider.selectedDate}");
        provider.getTodosFromFireStore();
      },
      dayProps: EasyDayProps(
          activeDayStyle: const DayStyle(
              dayNumStyle: TextStyle(color: AppColors.white, fontSize: 20)),
          inactiveDayStyle: DayStyle(
              dayNumStyle:
                  TextStyle(color: themeProvider.dayNumColor, fontSize: 20),
              decoration: BoxDecoration(
                  color: themeProvider.easyDayPropsDayColor,
                  borderRadius: BorderRadius.circular(14))),
          todayHighlightStyle: TodayHighlightStyle.withBackground,
          todayHighlightColor: themeProvider.easyDayPropsDayColor),
    );
  }
}
