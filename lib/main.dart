import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/wrapper.dart';
import 'package:devotionals/utils/constants/db_consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/theme/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox(videoIdsBox);
  await Hive.openBox('buddies');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>.value(value: AuthService().authStateChanges, initialData: null),
        StreamProvider<bool>(
            create: (context) => UserService().getPresence('userId'), // Replace 'userId' with the actual user ID
            initialData: false,
          ),
          
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRIC',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const Wrapper(),
    );
  }
}
