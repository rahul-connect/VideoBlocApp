import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktokapp/blocs/loginBloc/login_bloc.dart';
import 'package:tiktokapp/blocs/loginBloc/login_event.dart';
import 'package:tiktokapp/blocs/loginBloc/login_state.dart';

import 'home_screen.dart';


class LoginPageParent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>LoginBloc(),
      child: LoginPage(),
      
    );
  }
}


class LoginPage extends StatelessWidget {
  LoginBloc loginBloc;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          loginBloc.add(LoginButtonPressedEvent(
              email: emailController.text, password: passwordController.text));
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0)),
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 155.0,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 45.0),
            emailField,
            SizedBox(height: 25.0),
            passwordField,
            SizedBox(
              height: 35.0,
            ),
            loginButon,
            SizedBox(
              height: 15.0,
            ),
                BlocListener<LoginBloc,LoginState>(
          listener: (context,state){
            if(state is LoginSuccessState){
              navigateToHomePage(context,state.user);
            }
          },
            child: BlocBuilder<LoginBloc,LoginState>(builder: (context,state){
            if(state is LoginInitialState){
              return buildInitialUi();
            }else if(state is LoginLoadingState){
              return buildLoading();
            }else if(state is LoginSuccessState){
              return Container();
            }else if(state is LoginFailureState){
              return buildFailure(state.message);
            }else{
              return SizedBox.shrink();
            }
          }),
        ),
          ],
        ),
              ),
            ),
          ),
      ),
    );
  }

     Widget buildInitialUi(){
    return SizedBox.shrink();
  }

  Widget buildLoading(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildFailure(String message){
    return Text(message,style:TextStyle(color:Colors.red));
  }

  void navigateToHomePage(BuildContext context,FirebaseUser user){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context){
        return HomePageParent(user:user);
      }
    ));
  }
}
