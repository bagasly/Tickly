import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/bloc/login/login_cubit.dart';
import 'package:tickly/screen/home_screen.dart';
import 'package:tickly/screen/login.dart';
import 'package:tickly/utils/routes.dart';
import 'firebase_options.dart';
import 'bloc/register/register_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
      ],
      child: MaterialApp(
          title: "Tickly",
          debugShowCheckedModeBanner: false,
          navigatorKey: NAV_KEY,
          onGenerateRoute: generateRoute,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return const HomeScreen();
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              } else {
                return const LoginScreen();
              }
            },
          )),
    );
  }
}
