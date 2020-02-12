import 'package:flutter/material.dart';
import './ui/screens/login_screen.dart';
import './blocs/authBloc/auth_state.dart';
import './ui/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './blocs/authBloc/auth_bloc.dart';
import './ui/screens/splash_screen.dart';
import './blocs/authBloc/auth_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tik Tok Clone',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: BlocProvider(
        create: (context)=>AuthBloc()..add(AppStartedEvent()),
        child: Authenticate()),
    );
  }
}


class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc,AuthState>(
      builder: (context,state){
        if(state is AuthInitialState){
          return SplashPage();
        }else if(state is AuthenticatedState){
          return HomePageParent(user: state.user,);
        }else if(state is UnAuthenticatedState){
          return LoginPageParent();
        }
      },
    );
  }
}