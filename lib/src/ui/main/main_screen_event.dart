import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  List<Object?> get props => [];
}

class MainScreenLocationCheckEvent extends MainScreenEvent {}
