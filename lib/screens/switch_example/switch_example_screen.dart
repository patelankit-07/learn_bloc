import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahil_assignment/bloc/switch_bloc/switch_bloc.dart';
import 'package:sahil_assignment/bloc/switch_bloc/switch_event.dart';
import 'package:sahil_assignment/bloc/switch_bloc/switch_state.dart';

class SwitchExampleScreen extends StatefulWidget {
  const SwitchExampleScreen({super.key});

  @override
  State<SwitchExampleScreen> createState() => _SwitchExampleScreenState();
}

class _SwitchExampleScreenState extends State<SwitchExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Switch Example Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Notifications"),
                BlocBuilder<SwitchBloc, SwitchState>(
                    buildWhen: (previous,current)=>previous.isSwitch!=current.isSwitch,
                    builder: (context, state) {
                  return Switch(
                      value: state.isSwitch,
                      onChanged: (newValue) {
                        context.read<SwitchBloc>().add(EnableOrDisableSwitch());
                      });
                }),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            BlocBuilder<SwitchBloc, SwitchState>(builder: (context, state) {

              return Container(
                height: 250,
                color: Colors.amber.withOpacity(state.slider),
              );
            }),
            const SizedBox(
              height: 55,
            ),
            BlocBuilder<SwitchBloc, SwitchState>(
              buildWhen: (previous,current)=>previous.slider!=current.slider,
                builder: (context, state) {
              return Slider(
                  value: state.slider,
                  onChanged: (newValue) {
                    context.read<SwitchBloc>().add(SliderEvents(slider: newValue));
                  });
            }),
          ],
        ),
      ),
    );
  }
}
