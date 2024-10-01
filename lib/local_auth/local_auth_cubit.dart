// import '../../../core/extensions/extension_exports.dart';
//
// class LocalAuthCubit extends Cubit<LocalAuthState> {
//   final LocalAuthRepo _repo;
//
//   LocalAuthCubit(this._repo) : super(LocalAuthState());
//
//   Future<bool> checkBioMatricEnabled() async {
//     final bioMetricEnabled = await _repo.getBioMatricList();
//     return bioMetricEnabled.isNotEmpty;
//   }
//
//   Future<void> toggleBioMetric(bool isOn) async {
//     try {
//       bool isEnabled = true;
//       console(isOn);
//       if (isOn) {
//         final bioMetrics = await _repo.getBioMatricList();
//         if (bioMetrics.isEmpty) {
//           // this will show the dialog to enroll the biometric and always returns false
//           ///isEnabled = await LocalAuthRepo.enrollAuth();
//           navigator.pop();
//           await openBiometricEnableBottomSheet();
//         }
//       }
//       if (isEnabled) {
//         if (Platform.isIOS && !(await appService.getIOSConsent())) {
//           if (!(await _repo.enrollAuth())) return;
//           appService.setIOSConsent(true);
//         }
//         final res = await authenticate();
//         if (res) {
//           updateBioMetricEnabled(isOn);
//         }
//         if((isOn && res) || (!isOn && !res) ){
//           await appService.setBioMetricState(true);
//         }else if(isOn && !res || !isOn && res){
//           await appService.setBioMetricState(false);
//         }
//         Utils.triggerHaptic();
//       }
//     } on PlatformException catch (e) {
//       if (e.code == "NotAvailable") {
//         Utils.showWarning("Setup a lock screen to use Bio Metrics.");
//       }
//     }
//   }
//
//   Future<void> initAuth() async {
//     final isEnable = await checkBioMatricEnabled();
//     if (isEnable) {
//       final isBioMetricEnabled = await appService.getBioMetricState();
//       updateBioMetricEnabled(isBioMetricEnabled);
//       return;
//     }
//     updateBioMetricEnabled(isEnable);
//   }
//
//   void updateBioMetricEnabled(bool value) {
//     emit(state.copyWith(isBioMetricEnabled: value));
//   }
//
//   Future<bool> authenticate() async {
//     try {
//       Device device = Device();
//       final canAuth = await _repo.checkIfAuthenticate();
//
//       if (!canAuth) {
//         return false;
//       }
//
//       if (Platform.isAndroid &&
//           device.platformSDKVersion < AndroidVersion.q.sdkVersion) {
//         // directly initiating auth process, fallbacks to non-biometric if fails.
//         final res = await _repo.enrollAuth();
//         updateAuthenticated(res);
//         return res;
//       }
//
//       final bioMetrics = await _repo.getBioMatricList();
//       final res = await _repo.authenticate(bioMetrics);
//       updateAuthenticated(res);
//       return res;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   void updateAuthenticated(bool value) {
//     emit(state.copyWith(isAuthenticated: value));
//   }
//
//   void startLocalAuthProcess({bool? forceFully}) {
//     try {
//       if ((forceFully ?? state.isInActive) &&
//           state.isBioMetricEnabled) {
//         authenticate();
//       }
//     } catch (e) {}
//   }
//
//   void makeAuthInactive() {
//     try {
//       if (!state.isProcessing) {
//         emit(state.copyWith(isInActive: true));
//       }
//     } catch (e) {}
//   }
//
//   void submitPasscodeViaLocalAuth(bool isAuthenticated) {
//     try {
//       if (isAuthenticated) {
//         {
//           Future.delayed(Duration(milliseconds: 400), () {
//             if (gNextRoute.isNotEmpty) {
//               navigator.pushAndRemoveAll(getRouteByBackendName(gNextRoute),
//                   rootRoute: (gNextRoute == gRootRoute)
//                       ? null
//                       : getRouteByBackendName(gRootRoute));
//             } else if (gNextRoute.isEmpty && gRootRoute.isNotEmpty) {
//               navigator.pushAndRemoveAll(getRouteByBackendName(gRootRoute));
//             }
//           });
//         }
//         updateAuthenticated(false);
//       } else {}
//     } catch (e) {}
//   }
// }
