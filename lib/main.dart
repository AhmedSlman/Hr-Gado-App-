import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/general/my_bloc_observer.dart';
import 'core/locator/locator_setup.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupLocator();
    Bloc.observer = MyBlocObserver();
    runApp(const MyApp());
  }, (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
}
