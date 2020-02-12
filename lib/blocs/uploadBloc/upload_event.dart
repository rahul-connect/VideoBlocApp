import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class UploadEvent extends Equatable{}




class UploadButtonPressed extends UploadEvent{
  
  String uid;
  UploadButtonPressed({@required this.uid});
  @override
  List<Object> get props => [uid];

}


class LikedButtonPressed extends UploadEvent{
  
  DocumentSnapshot videoReference;
  String uid;
  LikedButtonPressed({@required this.uid,@required this.videoReference});
  @override
  List<Object> get props => [uid,videoReference];

}





