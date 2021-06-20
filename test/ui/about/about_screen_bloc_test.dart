import 'package:feather/src/ui/about/bloc/about_screen_bloc.dart';
import 'package:feather/src/ui/about/bloc/about_screen_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AboutScreenBloc aboutScreenBloc;

  setUp(() {
    aboutScreenBloc = AboutScreenBloc();
  });

  test("Initial state is InitialAboutScreenState", () {
    expect(aboutScreenBloc.state, InitialAboutScreenState());
  });
}
