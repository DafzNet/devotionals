import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/media/audio/services/audio_handler.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:devotionals/screens/onboarding/onboarder.dart';
import 'package:devotionals/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'utils/theme/theme.dart';
import 'package:get_it/get_it.dart'; // Replace with the actual file name

final GetIt getIt = GetIt.instance;

Future setupLocator() async{
  getIt.registerLazySingleton<AudioManager>(() => AudioManager());
  getIt.registerLazySingleton<Playing>(() => Playing());
  getIt.registerSingleton<AudioHandler>((await initAudioService()));
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HttpOverrides.global = MyHttpOverrides();

  
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
  void initState() {
    super.initState();
    // getIt<PageManager>().init();
    _getFirstTimeStatus();
  }

  @override
  void dispose() {
    // getIt<PageManager>().dispose();
    super.dispose();
  }


  bool _firstTime = false;

  Future _getFirstTimeStatus()async{
    SharedPreferences pref = await  SharedPreferences.getInstance();
    _firstTime = pref.getBool('is_first_time') ?? true;

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRIC',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: _firstTime? Onboarder() : const Wrapper(),
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
