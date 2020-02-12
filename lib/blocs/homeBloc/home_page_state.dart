import 'package:equatable/equatable.dart';


abstract class HomePageState extends Equatable{}


class HomePageInitial extends HomePageState{
  @override
  List<Object> get props => null;

}

class LogoutSuccess extends HomePageState{
  @override
  List<Object> get props => null;

}




class VideosFetching extends HomePageState{
  @override
  List<Object> get props => null;

}


class VideosFetched extends HomePageState{
  final Stream videos;
  VideosFetched(this.videos);

  @override
  List<Object> get props => [videos];

}










