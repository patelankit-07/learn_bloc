// import '../../../core/extensions/bloc_extension.dart';
//
// class LocalAuthState extends BaseCubitState {
//   final bool isBioMetricEnabled;
//   final bool isAuthenticated;
//   final bool isInActive;
//
//   LocalAuthState({
//     this.isBioMetricEnabled = false,
//     this.isAuthenticated = false,
//     this.isInActive = false,
//     super.isProcessing = false,
//   });
//
//   LocalAuthState copyWith({
//     bool? isBioMetricEnabled,
//     bool? isAuthenticated,
//     bool? isInActive,
//     bool? isProcessing,
//   }) {
//     return LocalAuthState(
//       isProcessing: isProcessing ?? this.isProcessing,
//       isBioMetricEnabled: isBioMetricEnabled ?? this.isBioMetricEnabled,
//       isAuthenticated: isAuthenticated ?? this.isAuthenticated,
//       isInActive: isInActive ?? this.isInActive,
//     );
//   }
//
//   @override
//   BaseCubitState clearState() => LocalAuthState();
//
//   @override
//   BaseCubitState startProcessing() => copyWith(isProcessing: true);
//
//   @override
//   BaseCubitState stopProcessing() => copyWith(isProcessing: false);
// }
