import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p8/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(child: App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 86, 129, 183)),
      ),
      home: SplashScreen()//StreamBuilder(
          //stream: FirebaseAuth.instance.authStateChanges(),
         // builder: (context, snapshot) {
            //if(snapshot.connectionState==connectionState.wating){return splashscreen();}
            //if (snapshot.hasData) {
            //  return TabScreen();
           // }
           // return AuthenticationScreen();
         // }),
    );
  }
}
