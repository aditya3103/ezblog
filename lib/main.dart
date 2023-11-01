import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'new_blog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders(
      [EmailAuthProvider(), GoogleProvider(clientId: 'clientId')]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int myindex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) => SignInScreen(
              actions: [
                AuthStateChangeAction<SignedIn>((context, _) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }),
              ],
              // ...
            ),
        '/profile': (context) => ProfileScreen(
              actions: [
                SignedOutAction((context) {
                  Navigator.of(context).pushReplacementNamed('/sign-in');
                }),
              ],
            ),
        '/create': (context) => Scaffold(
              body: NewBlog(), // Use your NewBlog widget here
            ),
        '/home': (context) => Scaffold(
            appBar: AppBar(
              title: Text('EzBlog'),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue,
              onTap: (index) {
                setState(() {
                  myindex = index;
                });
              },
              currentIndex: myindex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Create',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: Colors.blue[900],
            ))
      },
    );
  }
}
