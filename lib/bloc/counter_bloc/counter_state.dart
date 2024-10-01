import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int counter;

  const CounterState({this.counter = 0});

  CounterState copyWith({int? counter}) {
    // Maine yaha copyWith ka method create kiya
    // copyWith yeh karta ki CounterState ka new instance create kar deta hai
    // jo ki help karta hai override karta counter value ko change kar sake

    return CounterState(
        // if counter ka value null hoga to final me jo value pass kiye hai wo dikhayega //
        counter: counter ?? this.counter);
  }

  @override
  List<Object?> get props => [counter];
}
