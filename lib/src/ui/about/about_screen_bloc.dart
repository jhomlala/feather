import 'package:feather/src/ui/about/about_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'about_screen_state.dart';

class AboutScreenBloc extends Bloc<AboutScreenEvent, AboutScreenState> {
  AboutScreenBloc() : super(InitialAboutScreenState());

  @override
  Stream<AboutScreenState> mapEventToState(AboutScreenEvent event) async* {}
}
