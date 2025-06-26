import 'package:devconnect/auth/authentication_tab.dart';
import 'package:devconnect/core/colors.dart';
import 'package:devconnect/core/jwtservice.dart';
import 'package:devconnect/tabs/screens/addPost.dart';
import 'package:devconnect/tabs/screens/drawerscreen.dart';
import 'package:devconnect/tabs/screens/groupscreen.dart';
import 'package:devconnect/tabs/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final PageController controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      Homescreen(
        ontap: () {
          controller.animateToPage(
            1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );

          setState(() {
            index = 1;
          });
        },
      ),
      Addpost(),
      Groupscreen()
    ];

    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/DevConnect.png',
          height: 150.h,
          width: 150.h,
        ),
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/0201IT211057.jpg',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                JWTService.deletetoken();
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AuthenticationTab()),
                  (route) => false,
                );
              },
              label: Text('Logout'),
              icon: Icon(Icons.logout),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Drawerscreen(),
      ),
      body: PageView.builder(
        itemCount: screens.length,
        controller: controller,
        physics: NeverScrollableScrollPhysics(), // Prevent swipe navigation
        itemBuilder: (context, index) => screens[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: seedcolor,
        onTap: (value) {
          if (value != 1) {
            setState(() {
              index = value;
              controller.animateToPage(
                value,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.transparent),
            label: '', // Dummy for center FAB
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Group'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: index == 1 ? seedcolor : Colors.grey,
        ),
        onPressed: () {
          controller.animateToPage(
            1,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            index = 1;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
