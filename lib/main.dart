import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_sheets/screens/screens.dart';

import 'blocs/blocs.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BlocProvider(
        create: (context) => TableBloc()..add(const ConnectEvent()),
        child: Builder(
          builder: (context) {
            return const TableScreen();
          },
        ),
      ),
    );
  }
}
