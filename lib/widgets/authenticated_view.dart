import 'package:flutter/material.dart';

import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/settings_screen.dart';
import 'package:tipid/widgets/bottom_bar.dart';

class AuthenticatedView extends StatefulWidget {
  @override
  AuthenticatedViewState createState() {
    return AuthenticatedViewState();
  }
}

class AuthenticatedViewState extends State<AuthenticatedView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedTab = 0;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTabViews(),
      bottomNavigationBar: BottomBar(
        currentIndex: selectedTab,
        onTap: (int newIndex) {
          setState(() {
            selectedTab = newIndex;
            tabController.index = newIndex;
          });
        },
      ),
    );
  }

  Widget _buildTabViews() {
    return TabBarView(
      controller: tabController,
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        DashboardScreen(),
        SettingsScreen(),
      ],
    );
  }
}
