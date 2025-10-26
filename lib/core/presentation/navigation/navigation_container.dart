import 'dart:convert';

import 'package:dairy_app/feature/collections/presentation/pages/today_collections_history_page.dart';
import 'package:dairy_app/feature/farmers/presentation/pages/farmers_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/theme/colors.dart';
import '../../../feature/collections/presentation/pages/collection_stats.dart';
import '../../../feature/home/presentation/page/home_page.dart';
import '../../../feature/profile/presentation/pages/profile_page.dart';
import '../../../feature/sales/presentation/pages/sales_page.dart';
import '../../../feature/totals/presentation/pages/totals_collections_page.dart';
import '../../../feature/totals/presentation/pages/totals_collector_page.dart';
import '../../data/dto/login_response_dto.dart';
import '../../di/injector_container.dart';

class BottomNavigationContainer extends StatefulWidget {
  const BottomNavigationContainer({super.key});

  @override
  State<BottomNavigationContainer> createState() =>
      _BottomNavigationContainerState();
}

class _BottomNavigationContainerState extends State<BottomNavigationContainer> {
  int currentIndex = 0;
  String? role;

  final List<Widget> _screens = <Widget>[
    TodaysCollectionsPage(),
    const HomePage(),
    const CollectorsStats(),
    const FarmersPage(),
    // const TotalsPage()
  ];

  void _updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  void fetchUserRole() {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final roles = user.roles!.map((e) => e.name).toList();
    final role = roles[0];
    if (role == "SALES_PERSON") {
      setState(() {
        //_screens.add(const ProfilePage());
        this.role = "SALES_PERSON";
        _screens.removeAt(1);
        _screens.insert(1, const SalesPage());
      });
    } else if (role == "TOTALS_COLLECTOR") {
      setState(() {
        this.role = "TOTALS_COLLECTOR";
        _screens.removeAt(0);
        _screens.insert(0, const TotalsCollectorHomePage());
        _screens.removeAt(1);
        _screens.insert(1, const TotalsCollectionsHistory());
        _screens.removeAt(2);
        //_screens.insert(2, const ProfilePage());
      });
    } else {
      setState(() {
        _screens.add(const ProfilePage());
        this.role = "MILK_COLLECTOR";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: isDarkMode
            ? AppColors.darkColorScheme.onSurface
            : AppColors.lightColorScheme.onSurface,
        selectedIndex: currentIndex,
        animationDuration: const Duration(milliseconds: 200),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _updateIndex,
        destinations: _buildNavigationDestinations(),
        /*[
          role == "Sales Person" ?
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            selectedIcon: Icon(Icons.person),
          ) : NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home_filled),
          ),
        ],*/
      ),
    );
  }

  List<Widget> _buildNavigationDestinations() {
    final List<Widget> navigationDestinations = [];
    if (role == "SALES_PERSON") {
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          selectedIcon: Icon(Icons.home_filled),
        ),
      );
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.energy_savings_leaf_outlined),
          label: 'Sales',
          selectedIcon: Icon(Icons.energy_savings_leaf_sharp),
        ),
      );
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.trending_down_sharp),
          label: 'Collections',
          selectedIcon: Icon(Icons.trending_down_sharp),
        ),
      );
      /*navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
          selectedIcon: Icon(Icons.person),
        ),
      );*/
    } else if (role == "MILK_COLLECTOR") {
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.trending_down_sharp),
          label: 'Collections',
          selectedIcon: Icon(Icons.trending_down_sharp),
        ),
      );
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.query_stats_outlined),
          label: 'Stats',
          selectedIcon: Icon(Icons.query_stats),
        ),
      );
      navigationDestinations
          .add(const NavigationDestination(icon: Icon(Icons.summarize), label: "Totals"));
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Farmers',
          selectedIcon: Icon(Icons.people),
        ),
      );
    } else {
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          selectedIcon: Icon(Icons.home_filled),
        ),
      );
      navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.trending_down_sharp),
          label: 'Collections',
          selectedIcon: Icon(Icons.trending_down_sharp),
        ),
      );
      /*navigationDestinations.add(
        const NavigationDestination(
          icon: Icon(Icons.person_2_outlined),
          label: 'Profile',
          selectedIcon: Icon(Icons.person),
        ),
      );*/
    }
    return navigationDestinations;
  }
}
