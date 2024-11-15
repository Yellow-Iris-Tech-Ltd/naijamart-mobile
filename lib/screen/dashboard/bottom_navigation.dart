import 'package:flutter/material.dart';

import '../../common/mixins/automatic_logout_mixin.dart';
import '../../util/cache/local.dart';
import '../../util/constants/images_uri.dart';
import '../../util/constants/naijamart_app_colors.dart';
import 'me_screen.dart';


class DashboardNavigationScreen extends StatefulWidget {
  static const routeName = '/dashboard-navigation';
  // final int initialSelectedIndex;

   const DashboardNavigationScreen({
    super.key,
    // required this.initialSelectedIndex
  });

  @override
  State<DashboardNavigationScreen> createState() => _DashboardNavigationScreenState();
}

class _DashboardNavigationScreenState extends State<DashboardNavigationScreen> with AutomaticLogoutMixin  {


  int _selectedItemIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    init();
  }


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey('initialSelectedIndex')) {
      setState(() {
        _selectedItemIndex = args['initialSelectedIndex'];
      });
    }
  }



  void init() async {
    _pages = [
      const MeDashboardScreen(),
    ];
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget _bottomTab(){
    return BottomNavigationBar(
        currentIndex: _selectedItemIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: NaijaMartAppColors.YelloGrad1,
        unselectedItemColor: Colors.black54,
        elevation: 20,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 14,
        items:   <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: customBottomNav(context, false, 'Me', NaijaMartImageUris.meImage),
            activeIcon: customBottomNav(context, true, 'Me', NaijaMartImageUris.meActiveImage),
            label: '',
          ),
        ]
    );
  }

  void _onTap(int index) {
    onUserInteraction();
    setState(() {
      _selectedItemIndex = index;
    });
  }

  Widget customBottomNav(BuildContext context, bool isActiveIcon, String text, String icon) {
    if (isActiveIcon) {
      return Column(
        children: [
          Image.asset(icon, height: 20, width: 20),
          const SizedBox(height: 5,),
          Text('$text', style: const TextStyle(fontSize: 16, color: NaijaMartAppColors.YelloGrad1, fontWeight: FontWeight.w800)),
        ],
      );
    } else {
      return Column(
        children: [
          Image.asset(icon, height: 16, width: 16, color: Colors.black, ),
          Text('$text', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomTab(),
        body: _pages[_selectedItemIndex],
      ),
    );
  }
}
