import 'package:flutter/material.dart';
import 'package:flutter_login_session/layout/homepage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_session/repository/login_repository.dart';
import '../bloc/login_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => LoginRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  LoginBloc(loginRepository: context.read<LoginRepository>())
                    ..add(const InitLogin()),
            ),
          ],
          child: HomePage(),
        ),
      ),
    );
  }
}
