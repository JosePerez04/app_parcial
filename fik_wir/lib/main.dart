import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';
import 'screens/feed_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '832382792164-3ia4un0d0ckqno0669qe9gdlambeber4.apps.googleusercontent.com',
    );
  } catch (e) {
    
  }
  runApp(const MyApp());
}


class AuthNotifier extends ChangeNotifier {
  late final StreamSubscription sub;
  AuthNotifier() {
    sub = FirebaseAuth.instance
        .authStateChanges()
        .listen((user) => notifyListeners());
  }
  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/login',
  refreshListenable: AuthNotifier(),
  redirect: (context, state) {
    final logged = FirebaseAuth.instance.currentUser != null;
    final loc = state.matchedLocation;
    final enAuth = loc == '/login' || loc == '/registro';
    if (!logged) return enAuth ? null : '/login';
    if (enAuth) return '/feed';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/registro',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/feed',
      builder: (context, state) => const FeedScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'fikwir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      routerConfig: router,
    );
  }
}