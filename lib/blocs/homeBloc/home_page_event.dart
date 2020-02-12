import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable{}


class LogOutButtonPressedEvent extends HomePageEvent{
  @override
  List<Object> get props => null;

}



class FetchVideos extends HomePageEvent{
  final user;
  FetchVideos(this.user);
  @override
  List<Object> get props => null;

}