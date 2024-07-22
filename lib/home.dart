import 'package:expense_tracker/widgets/expenses_widget.dart';
import 'package:expense_tracker/widgets/gallery_widget.dart';
import 'package:expense_tracker/widgets/home_widget.dart';
import 'package:expense_tracker/widgets/settings_widget.dart';
import 'package:expense_tracker/widgets/stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'util/functions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Functions {
  int navIndex = 0;
  Map<int, bool> currentView = {
    0: true,
    1: false,
    2: false,
    3: false,
    4: false,
  };

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    backgroundWork(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                HomeWidget(views: currentView),
                ExpensesWidget(
                  views: currentView,
                  scrollController: scrollController,
                ),
                StatsWidget(views: currentView),
                GalleryWidget(views: currentView),
                SettingsWidget(views: currentView),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: navIndex,
        onTap: (i) {
          setState(() {
            navIndex = i;
            currentView.forEach((key, value) {
              currentView[key] = false;
            });
            currentView[i] = true;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.monetization_on_outlined),
            title: const Text('Expenses'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.bar_chart),
            title: const Text('Stats'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.photo_library_outlined),
            title: const Text('Gallery'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Settings'),
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 0, 182, 218),
      ),
    );
  }
}
