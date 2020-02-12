import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import '../../blocs/uploadBloc/bloc.dart';
import 'package:flutter_share/flutter_share.dart';


class VideoApp extends StatefulWidget {
  final videoReference;
  final String user;

  VideoApp({@required this.user,@required this.videoReference});
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  bool isLiked;
  

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoReference['fileUrl'])
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

      if(widget.videoReference['isLiked'].contains(widget.user)){
        setState(() {
          isLiked=true;
        });
      }else{
        setState(() {
          isLiked=false;
        });
      }

  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
         title:Text(""),
      ),
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(backgroundColor: Colors.yellow,),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FloatingActionButton(child: Icon(isLiked?Icons.favorite:Icons.favorite_border,color: Colors.pink,size: 33.0,),onPressed: (){
                setState(() {
                  isLiked = !isLiked;
                });
                BlocProvider.of<UploadBloc>(context).add(LikedButtonPressed(uid:widget.user,videoReference:widget.videoReference));
              },heroTag: "favourite",backgroundColor: Colors.white,),
               FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                heroTag: "VideoControl",
              ),
                 FloatingActionButton(child: Icon(Icons.share,color: Colors.blue,size: 33.0,),onPressed: ()async{
                   await FlutterShare.share(
      title: 'Watch this Awesome Video !',
      linkUrl: widget.videoReference['fileUrl'],
    );
              },heroTag: "share",backgroundColor: Colors.white,),
             
            ],
          ),
        ),
      
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}