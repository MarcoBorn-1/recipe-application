import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_snack_bar.dart';
import 'package:frontend/profile/login_register/widgets/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/screens/homepage_screen.dart';
import 'package:frontend/common/providers/intolerance_provider.dart';
import 'package:frontend/search/screens/search_option_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((val) {
    runApp(const MyApp());
  });
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: IntolerancesProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: const MaterialColor(0xFF221722, color),
          ),
          home: const MyBottomNavigator(),
        ));
  }
}

class MyBottomNavigator extends StatefulWidget {
  const MyBottomNavigator({super.key});

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
      const HomePage(),
      const SearchOptionScreen(),
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
    User? user = Auth().currentUser;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        String desc = message.notification?.body ?? "";
        if (desc != "" && message.data['receiving_user'] == user?.uid) {
          showSnackBar(context, desc, SnackBarType.info);
        }

        if (message.notification!.title != null) {
          print(message.notification!.title);
        }
        if (message.notification!.body != null) {
          print(message.notification!.body);
        }
      }
    });
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor:
          const MaterialColor(0xFF221722, color), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: const MaterialColor(0xFF221722, color),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popAllScreensOnTapAnyTabs: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }
}
