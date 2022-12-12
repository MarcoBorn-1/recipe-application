import 'package:flutter/cupertino.dart';
import 'package:frontend/auth/screens/test_home_page.dart';
import 'package:frontend/auth/widgets/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/screens/main_page.dart';
import 'package:frontend/recipe/screens/recipe_page.dart';
import 'package:frontend/search/screens/search_option_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const Map<int, Color> color = {
    50: Color.fromRGBO(34, 23, 34, .1),
    100: Color.fromRGBO(34, 23, 34, .2),
    200: Color.fromRGBO(34, 23, 34, .3),
    300: Color.fromRGBO(34, 23, 34, .4),
    400: Color.fromRGBO(34, 23, 34, .5),
    500: Color.fromRGBO(34, 23, 34, .6),
    600: Color.fromRGBO(34, 23, 34, .7),
    700: Color.fromRGBO(34, 23, 34, .8),
    800: Color.fromRGBO(34, 23, 34, .9),
    900: Color.fromRGBO(34, 23, 34, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xFF221722, color),
      ),
      home: MyBottomNavigator(),
    );
  }
}

class MyBottomNavigator extends StatefulWidget {
  @override
  State<MyBottomNavigator> createState() => _MyBottomNavigatorState();
}

class _MyBottomNavigatorState extends State<MyBottomNavigator> {
  static const Map<int, Color> color = {
    50: Color.fromRGBO(34, 23, 34, .1),
    100: Color.fromRGBO(34, 23, 34, .2),
    200: Color.fromRGBO(34, 23, 34, .3),
    300: Color.fromRGBO(34, 23, 34, .4),
    400: Color.fromRGBO(34, 23, 34, .5),
    500: Color.fromRGBO(34, 23, 34, .6),
    600: Color.fromRGBO(34, 23, 34, .7),
    700: Color.fromRGBO(34, 23, 34, .8),
    800: Color.fromRGBO(34, 23, 34, .9),
    900: Color.fromRGBO(34, 23, 34, 1),
  };
  
  List<Widget> _buildScreens() {
      return [
        const MyHomePage(),
        SearchOptionScreen(),
        const WidgetTree(),
      ];
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.home),
                title: ("Home"),
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
                icon: const Icon(CupertinoIcons.search),
                title: ("Search"),
                activeColorPrimary: CupertinoColors.activeBlue,
                inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.person),
              title: "Profile",
              activeColorPrimary: CupertinoColors.activeBlue,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            )
        ];
    }
    
  @override
  Widget build(BuildContext context) {
   PersistentTabController controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
        context,
        controller: controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: const MaterialColor(0xFF221722, color), // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: const MaterialColor(0xFF221722, color),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }
}
