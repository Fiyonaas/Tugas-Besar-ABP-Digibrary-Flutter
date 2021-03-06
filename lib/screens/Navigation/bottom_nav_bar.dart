import 'package:flutter/material.dart';
import 'package:lms/screens/Dashboard/dashboard_screen.dart';
import 'package:lms/screens/Home/home_screen.dart';
import 'package:lms/screens/Profile/profile_screen.dart';
import 'package:lms/services/authentication_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';

class BottomNavPanel extends StatefulWidget {
  const BottomNavPanel({Key? key}) : super(key: key);

  @override
  State<BottomNavPanel> createState() => _BottomNavPanelState();
}

class _BottomNavPanelState extends State<BottomNavPanel> {
  int currentIndex = 0;
  final _widgteOptions = <Widget>[
    const HomeScreen(),
    DashboardScreen(),
    const ProfileScreen()
  ];

  final _appBarWidget = <Widget>[
    const Text("Home"),
    const Text("Dashboard"),
    const Text("Profile")
  ];

  @override
  void initState() {
    super.initState();
    initPlateformState();
  }

  initPlateformState() async {
    await OneSignal.shared.setAppId(appId);

    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState != null && deviceState.userId != null) {
      var tokenId = deviceState.userId;
      await context.read<AuthenticationService>().saveTokenToDatabase(tokenId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                currentIndex: currentIndex,
                showUnselectedLabels: false,
                onTap: (index) => setState(() => currentIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_rounded),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  )
                ]),
            body: IndexedStack(
              index: currentIndex,
              children: _widgteOptions,
            )));
  }
}
