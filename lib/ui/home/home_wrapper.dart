import 'package:e_store/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'catalog/catalog.dart';

enum WidgetMarker { catalog, search, cart, user }

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.catalog;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppTheme.greenColor,
        appBar: AppBar(
          toolbarHeight: 50,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            FlatButton(
              onPressed: () {},
              child: Image.asset("assets/drawable/filter.png"),
            )
          ],
          title: Text("Catalog"),
          elevation: 0,
          backgroundColor: AppTheme.greenColor,
        ),
        bottomNavigationBar: _getBottomNavigation,
        body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)),
              color: Colors.white,
            ),
            child: getCustomContainer()),
      ),
    );
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.catalog:
        return Catalog();
        break;
      case WidgetMarker.search:
        return Column(
          children: [
            Center(
              child: Text(
                "SEARCH",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
        break;
      case WidgetMarker.cart:
        return Column(
          children: [
            Center(
              child: Text(
                "CART",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
        break;
      case WidgetMarker.user:
        return Column(
          children: [
            Center(
              child: Text(
                "USER",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
        break;
    }
    return Text("${selectedWidgetMarker.toString()}");
  }

  void _onItemTapped(int index) {
    selectedWidgetMarker = WidgetMarker.values[index];
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget get _getBottomNavigation => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/drawable/catalog.png"),
              color: Color(0xFF3A5A98),
            ),
            activeIcon: ImageIcon(
              AssetImage("assets/drawable/catalog.png"),
              color: Colors.red,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/drawable/serch_bottom_nav.png"),
              color: Color(0xFF3A5A98),
            ),
            activeIcon: ImageIcon(
              AssetImage("assets/drawable/serch_bottom_nav.png"),
              color: Colors.red,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/drawable/cart.png"),
              color: Color(0xFF3A5A98),
            ),
            activeIcon: ImageIcon(
              AssetImage("assets/drawable/cart.png"),
              color: Colors.red,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/drawable/user_account.png"),
              color: Color(0xFF3A5A98),
            ),
            activeIcon: ImageIcon(
              AssetImage("assets/drawable/user_account.png"),
              color: Colors.red,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      );
}
