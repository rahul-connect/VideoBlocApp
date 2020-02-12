import 'package:bloc/bloc.dart';
import './auth_event.dart';
import './auth_state.dart';
import '../../services/auth_service.dart';


class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthService authService;

  AuthBloc(){
    this.authService = AuthService();
  }

  @override
  AuthState get initialState => AuthInitialState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event)async* {
    if(event is AppStartedEvent){
      try{
           var isSignedIn = await authService.isSignedIn();
      if(isSignedIn){
        var user = await authService.getCurrentUser();
        yield AuthenticatedState(user:user);
      }else{
        yield UnAuthenticatedState();
      }
      }catch(e){
        yield UnAuthenticatedState();

      }
    }
  }

}