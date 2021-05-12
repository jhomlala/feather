import 'package:feather/src/ui/about/bloc/about_screen_event.dart';
import 'package:feather/src/ui/about/bloc/about_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AboutScreenBloc extends Bloc<AboutScreenEvent, AboutScreenState> {
  AboutScreenBloc() : super(InitialAboutScreenState());

  @override
  Stream<AboutScreenState> mapEventToState(AboutScreenEvent event) async* {}
}
