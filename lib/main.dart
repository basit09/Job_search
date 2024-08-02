import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/ui/screens/home_screen/employer_home_screen.dart';
import 'package:job_search/ui/screens/home_screen/jobseeker_home_screen.dart';
import 'package:job_search/ui/screens/login_screen/login_screen.dart';

import 'infrastructure/provider/provider_registration.dart';
import 'infrastructure/services/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseHelper.firebaseOptions());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    ref.read(authProvider).isUserLoggedIn();
    ref.read(authProvider).getUserRole();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ref.watch(authProvider).isLoggedIn
          ? navigateOnRole()
          : const LoginScreen(),
    );
  }

  navigateOnRole() {
    if (ref.watch(authProvider).selectedRole == 0) {
      return const EmployerHomeScreen();
    } else {
      return const JobseekerHomeScreen();
    }
  }
}
