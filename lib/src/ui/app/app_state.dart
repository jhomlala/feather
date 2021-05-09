import 'package:equatable/equatable.dart';
import 'package:feather/src/model/internal/unit.dart';

class AppState extends Equatable {
  final Unit unit;

  const AppState(this.unit);

  @override
  List<Object> get props => [unit];
}
