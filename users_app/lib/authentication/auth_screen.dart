import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TabBar get _tabBar => TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.white,
        dividerColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff231f20)),
        tabs: [
          Container(
            height: 40,
            child: const Tab(
              text: "Login",
            ),
          ),
          Container(
            height: 40,
            child: const Tab(
              text: "Register",
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xfff5f6fa),
                ),
                margin: EdgeInsets.only(right: 20, left: 20),
                child: _tabBar,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: const TabBarView(
                  children: [LoginScreen(), SignUpScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// PreferredSize(
//               preferredSize: _tabBar.preferredSize,
//               child: Container(
//                 margin: const EdgeInsets.only(left: 20, right: 20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xfff5f6fa),
//                 ),
//                 child: _tabBar,
//               ),
//             ),