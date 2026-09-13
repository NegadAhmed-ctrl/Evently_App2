import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/ui/home/tabs/profile/favorite/favorite_tab.dart';
import 'package:flutter_application_1/ui/home/tabs/profile/home/home_tab.dart';
import 'package:flutter_application_1/ui/home/tabs/profile/profile_tab.dart';
import 'package:flutter_application_1/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int SelectedIndex = 0;
  List<Widget> tabsList = [HomeTab(), FavoriteTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: SelectedIndex,
        onTap: (index) {
          SelectedIndex = index;
          setState(() {});
        },
        items: [
          _builtBottomNavBarItem(
            isSelected: SelectedIndex == 0,
            unSelectedIconsName: Icons.home_outlined,
            SelectedIconsName: Icons.home_max_rounded,
            label: AppLocalizations.of(context)!.home,
          ),
          _builtBottomNavBarItem(
            isSelected: SelectedIndex == 1,
            unSelectedIconsName: Icons.favorite_outline_outlined,
            SelectedIconsName: Icons.favorite,
            label: AppLocalizations.of(context)!.favorite,
          ),
          _builtBottomNavBarItem(
            isSelected: SelectedIndex == 2,
            unSelectedIconsName: Icons.person_2_outlined,
            SelectedIconsName: Icons.person,
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
      body: tabsList[SelectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, color: AppColors.whiteColor, size: 25),
      ),
    );
  }

  BottomNavigationBarItem _builtBottomNavBarItem({
    required String label,
    required IconData SelectedIconsName,
    required IconData unSelectedIconsName,
    required isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(isSelected ? SelectedIconsName : unSelectedIconsName),
      label: label,
    );
  }
}
