import 'package:equatable/equatable.dart';
import 'package:feather/src/data/model/internal/unit.dart';

class AppState extends Equatable {
  final Unit unit;

  const AppState(this.unit);

  @override
  List<Object> get props => [unit];
}
