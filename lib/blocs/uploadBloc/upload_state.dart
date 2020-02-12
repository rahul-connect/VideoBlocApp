import 'package:equatable/equatable.dart';


abstract class UploadState extends Equatable{

}



class UploadInitial extends UploadState{
  @override
  List<Object> get props => null;

}


class UploadingState extends UploadState{
  @override
  List<Object> get props => null;

}


class UploadSuccess extends UploadState{
  @override
  List<Object> get props => null;

}

class UploadFailed extends UploadState{
  @override
  List<Object> get props => null;

}


