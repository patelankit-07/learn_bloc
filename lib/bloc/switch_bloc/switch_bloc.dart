import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sahil_assignment/bloc/switch_bloc/switch_event.dart';
import 'package:sahil_assignment/bloc/switch_bloc/switch_state.dart';

class SwitchBloc extends Bloc<SwitchEvents, SwitchState> {

  SwitchBloc() : super(const SwitchState()) {
    on<EnableOrDisableSwitch>(enableOrDisableSwitch);
    on<SliderEvents>(sliders);
  }

  void enableOrDisableSwitch(EnableOrDisableSwitch event, Emitter<SwitchState> emit) {
    emit(state.copyWith(isSwitch: !state.isSwitch));
  }

  void sliders(SliderEvents event, Emitter<SwitchState> emit) {
    emit(state.copyWith(slider: event.slider));
  }

}
