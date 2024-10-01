import 'package:equatable/equatable.dart';

abstract class SwitchEvents extends Equatable {
   const SwitchEvents();

  @override
  List<Object> get props => [];
}


class EnableOrDisableSwitch extends SwitchEvents{}

class SliderEvents extends SwitchEvents{
  double slider;
  SliderEvents({required this.slider});

  @override
  List<Object> get props => [slider];

}

