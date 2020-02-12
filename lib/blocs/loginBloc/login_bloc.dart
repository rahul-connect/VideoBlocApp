import 'package:bloc/bloc.dart';
import './login_event.dart';
import './login_state.dart';
import '../../services/auth_service.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  AuthService authService;
  LoginBloc(){
    this.authService = AuthService();
  }

  @override
  LoginState get initialState => LoginInitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if(event is LoginButtonPressedEvent){
      try{
        yield LoginLoadingState();
      var user = await authService.signInUser(event.email, event.password);
      yield LoginSuccessState(user:user);
      }catch(e){
        yield LoginFailureState(message: e.toString());
      }

    }
  }

}