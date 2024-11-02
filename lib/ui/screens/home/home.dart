import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/ui/screens/bottom_sheet/bottom_sheet.dart';
import 'package:to_do_app/ui/screens/home/tabs/settings/settings.dart';
import 'package:to_do_app/ui/screens/home/tabs/todo_list/todo_list.dart';
import 'package:to_do_app/utils/extensions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String routeName = "home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List<Widget> tabs = [TodoList(), Settings()];
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: buildAppBar(),
      bottomNavigationBar: buildBottomNavigationBar(),
      floatingActionButton: const MyBottomSheet(),
      body: tabs[currentIndex],
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomAppBar(
      notchMargin: 10,
      shape: CircularNotchedRectangle(),
      padding: EdgeInsets.all(0),
      height: 70,
      clipBehavior: Clip.hardEdge,
      child: BottomNavigationBar(
        elevation: 0,
        currentIndex: currentIndex,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "")
        ],
        onTap: (selectedIcon) {
          currentIndex = selectedIcon;
          setState(() {});
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 30, left: 48),
        child: currentIndex == 0
            ? Text(
                context.localization.toDoList,
                style: Theme.of(context).textTheme.headlineSmall,
              )
            : Text(
                context.localization.settings,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
      ),
    );
  }
}
