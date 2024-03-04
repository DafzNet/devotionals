import 'package:devotionals/screens/auth/signin/login.dart';
import 'package:devotionals/screens/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  
  @override
  Widget build(BuildContext context) {

    User? user = Provider.of<User?>(context);
    
    return user != null? AppBaseNavigation(uid: user.uid):LoginScreen();
  }
}