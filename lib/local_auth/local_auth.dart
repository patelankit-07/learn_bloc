// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:local_auth_android/local_auth_android.dart';
//
// class LocalAuth {
//   // LocalAuth._();
//
//   final LocalAuthentication _auth = LocalAuthentication();
//   final AuthenticationOptions _options = AuthenticationOptions(
//     stickyAuth: true,
//     useErrorDialogs: true,
//   );
//   final List<AuthMessages> authMessages = [
//     AndroidAuthMessages(
//       signInTitle: 'Login with Biometric',
//       cancelButton: 'No thanks',
//     ),
//   ];
//
//   Future<bool> checkIfAuthenticate() async {
//     try {
//       final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
//
//       final bool canAuthenticate =
//           canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
//
//       return canAuthenticate;
//     } catch (e) {
//       // print(e);
//       return false;
//     }
//   }
//
//   Future<bool> stopAuthentication() async {
//     try {
//       return await _auth.stopAuthentication();
//     } catch (e) {
//       return false;
//     }
//   }
//
//   Future<List<BiometricType>?> getBioMatricList() async {
//     try {
//       Device device = Device();
//       if (Platform.isAndroid) {
//         if (device.platformSDKVersion < AndroidVersion.q.sdkVersion) {
//           print("Unsupported SDK Version: ${device.platformSDKVersion}");
//           return [];
//         }
//       }
//
//       final results = await _auth.getAvailableBiometrics();
//       return results;
//     } catch (e) {
//       // print(e);
//       return null;
//     }
//   }
//
//   Future<bool> authenticate() async {
//     try {
//       final bool didAuthenticate = await _auth.authenticate(
//         localizedReason: 'Please authenticate to continue',
//         options: _options,
//         authMessages: authMessages,
//       );
//       return didAuthenticate;
//     } on PlatformException catch (error) {
//       print("Authentication error: $error");
//       if (error.code == 'NotEnrolled' || error.code == "NotAvailable") {
//         try {
//           final didAuthenticate = await _auth.authenticate(
//               localizedReason: 'Authenticate to LogIn Breath Brake',
//               options: _options);
//           return didAuthenticate;
//         } on PlatformException catch (innerError) {
//           print("Secondary authentication error: $innerError");
//           return false;
//         }
//       }
//       return false;
//     }
//   }
//
//   Future<bool> enrollAuth() async {
//     try {
//       final isSuccess = await _auth.authenticate(
//         localizedReason: "Login with bio-metrics",
//         options: AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//         authMessages: authMessages,
//       );
//       // print(isSuccess);
//       return isSuccess;
//     } catch (e) {
//       // print(e);
//       rethrow;
//     }
//   }
// }
