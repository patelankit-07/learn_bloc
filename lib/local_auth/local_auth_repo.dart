//
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
// import 'local_auth.dart';
//
// class LocalAuthRepo {
//
//   static final LocalAuth _authService = LocalAuth();
//
//   Future<List<BiometricType>> getBioMatricList() async {
//     try {
//       final res = await _authService.getBioMatricList();
//       return res ?? [];
//     } catch (e) {
//       return [];
//     }
//   }
//
//   Future<bool> enrollAuth() async {
//     final result = await _authService.enrollAuth();
//     return result;
//   }
//
//   Future<bool> authenticate(List<BiometricType> bioMetrics) async {
//     try {
//       if (bioMetrics.isEmpty) {
//         return false;
//       }
//       final result = await _authService.authenticate();
//       return result;
//     } catch (e) {
//       if (e is PlatformException) rethrow;
//       return false;
//     }
//   }
//
//   Future<bool> checkIfAuthenticate() async {
//     try {
//       final result = await _authService.checkIfAuthenticate();
//       return result;
//     } catch (e) {
//       return false;
//     }
//   }
//
// }