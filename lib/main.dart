import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sahil_assignment/rahul_sir_task/provider/user_provider.dart';
import 'package:sahil_assignment/rahul_sir_task/screens/login_screen.dart';
import 'package:sahil_assignment/rahul_sir_task/screens/profile_screen.dart';
import 'package:sahil_assignment/rahul_sir_task/screens/register_screen.dart';
import 'package:sahil_assignment/rahul_sir_task/screens/splash_screen.dart';
import 'package:sahil_assignment/screens/image_picker/image_picker_screen.dart';
import 'package:sahil_assignment/screens/to_do_screen/to_do_screen.dart';
import 'package:sahil_assignment/trade/try_screen.dart';
import 'package:sahil_assignment/trade/trading_screen.dart';
import 'package:sahil_assignment/trade/widget/splash.dart';
import 'package:sahil_assignment/utils/image_picker.dart';
import 'bloc/counter_bloc/counter_bloc.dart';
import 'bloc/image_picker/image_picker_bloc.dart';
import 'bloc/switch_bloc/switch_bloc.dart';
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
