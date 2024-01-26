import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:devotionals/firebase/auth.dart';
import 'package:devotionals/firebase/dbs/user.dart';
import 'package:devotionals/screens/media/audio/services/audio_handler.dart';
import 'package:devotionals/screens/media/audio/services/manager.dart';
import 'package:devotionals/screens/media/audio/services/playing.dart';
import 'package:devotionals/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/theme/theme.dart';
import 'package:get_it/get_it.dart'; // Replace with the actual file name

final GetIt getIt = GetIt.instance;

void setupLocator() async{
  final _audio = await initAudioService();
  getIt.registerLazySingleton<AudioManager>(() => AudioManager());
  getIt.registerLazySingleton<Playing>(() => Playing());
  getIt.registerLazySingleton<AudioHandler>(() => _audio);
}





void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HttpOverrides.global = MyHttpOverrides();
  
  // _audioHandler = await AudioService.init(
  //   builder: () => MyAudioHandler(),
  //   config: AudioServiceConfig(
  //     androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
  //     androidNotificationChannelName: 'Music playback',
  //   ),
  // );
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


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
