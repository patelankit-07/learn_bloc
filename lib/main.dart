import 'package:flutter/material.dart';
import 'package:sahil_assignment/rahul_sir_task/screens/login_screen.dart';
import 'package:sahil_assignment/rahul_sir_task/screens/profile_screen.dart';
import 'package:sahil_assignment/rahul_sir_task/screens/splash_screen.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}


//   MultiBlocProvider(
//   providers: [
//     BlocProvider(
//       create: (_) => CounterBloc(),
//     ),
//     BlocProvider(
//       create: (_) => SwitchBloc(),
//     ),
//     BlocProvider(
//       create: (_) => ImagePickerBloc(ImagePickerUtils()),
//     ),
//   ],
//   child: const MaterialApp(
//       debugShowCheckedModeBanner: false, home: ToDoScreen()),
// );

//   MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: Scaffold(
//     backgroundColor: Colors.black,
//     body: SafeArea(
//       child: Splash(),
//     ),
//   ),
// );

// BlocProvider(
//   create: (_) => CounterBloc(),
//   child: BlocProvider(
//     create: (_) => SwitchBloc(),
//     child: const MaterialApp(
//         debugShowCheckedModeBanner: false, home: SwitchExampleScreen()),
//   ));
//   MaterialApp(
//   title: 'ToDo App',
//   home: RepositoryProvider(
//     create: (context) => TaskRepository(),
//     child: MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => TasksBloc(
//             RepositoryProvider.of<TaskRepository>(context),
//           )..add(LoadTask()),
//         ),
//       ],
//       child: const MyHomePage(),
//     ),
//   ),
// );
