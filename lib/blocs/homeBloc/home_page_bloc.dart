import 'package:bloc/bloc.dart';
import './home_page_event.dart';
import './home_page_state.dart';
import '../../services/auth_service.dart';
import '../../services/upload_service.dart';

class HomePageBloc extends Bloc<HomePageEvent,HomePageState>{
  AuthService authService;
  UploadService uploadService;

  HomePageBloc(){
    this.authService = AuthService();
    this.uploadService = UploadService();
  }
  
  
  @override
  HomePageState get initialState => HomePageInitial();

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event)async* {
    if(event is LogOutButtonPressedEvent){
      await authService.signOut();
      yield LogoutSuccess();
    }else if(event is FetchVideos){
      yield VideosFetching();
      final  videos = uploadService.fetchVideos(event.user);
      yield(VideosFetched(videos));

    }
  }
  
}