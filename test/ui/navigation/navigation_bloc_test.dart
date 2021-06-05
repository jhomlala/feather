import 'package:feather/src/ui/navigation/bloc/navigation_bloc.dart';
import 'package:feather/src/ui/navigation/navigation.dart';
import 'package:flutter/material.dart';

NavigationBloc buildNavigationBloc() => NavigationBloc(
      Navigation(),
      GlobalKey(),
    );
