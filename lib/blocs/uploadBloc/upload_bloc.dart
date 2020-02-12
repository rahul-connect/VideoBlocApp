
import './upload_event.dart';
import './upload_state.dart';
import 'package:bloc/bloc.dart';
import '../../services/upload_service.dart';


class UploadBloc extends Bloc<UploadEvent,UploadState>{
  UploadService uploadService;

  UploadBloc(){
    this.uploadService = UploadService();
  }
  
  @override
  UploadState get initialState => UploadInitial();

  @override
  Stream<UploadState> mapEventToState(UploadEvent event) async*{
    if(event is UploadButtonPressed){
      yield UploadingState();
      bool uploading = await uploadService.chooseFile(event.uid);
      if(uploading){
        yield UploadSuccess();
      }else{
        yield UploadFailed();
      }
      
    }else if(event is LikedButtonPressed){
      await uploadService.videoLiked(event.videoReference, event.uid);
    }
  }

}