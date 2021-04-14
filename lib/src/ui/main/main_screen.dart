import 'package:feather/src/ui/main/main_screen_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_screen_bloc.dart';
import 'main_screen_state.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainScreenBloc _mainScreenBloc;

  @override
  void initState() {
    super.initState();
    _mainScreenBloc = BlocProvider.of(context);
    _mainScreenBloc.add(MainScreenLocationCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          return Text(state.toString(),style: TextStyle(color: Colors.black, fontSize: 30),);
        },
      ),
    );
  }
}
