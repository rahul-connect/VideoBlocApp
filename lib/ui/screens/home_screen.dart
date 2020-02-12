import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktokapp/ui/screens/video_player.dart';
import '../../blocs/homeBloc/bloc.dart';
import '../../blocs/uploadBloc/bloc.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePageParent extends StatelessWidget {
  final FirebaseUser user;
  HomePageParent({@required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomePageBloc>(
            create: (context) => HomePageBloc()..add(FetchVideos(user.uid))),
        BlocProvider<UploadBloc>(
          create: (context) => UploadBloc(),
        ),
      ],
      child: HomePage(user),
    );
  }
}

class HomePage extends StatelessWidget {
  final FirebaseUser user;

  HomePage(this.user);

  HomePageBloc homePageBloc;
  UploadBloc uploadBloc;

  @override
  Widget build(BuildContext context) {
    homePageBloc = BlocProvider.of<HomePageBloc>(context);
    uploadBloc = BlocProvider.of<UploadBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              homePageBloc.add(LogOutButtonPressedEvent());
            },
          )
        ],
      ),
      body: BlocListener<HomePageBloc, HomePageState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            navigateToLoginPage(context);
          }
        },
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state is VideosFetching) {
              return Center(child: CircularProgressIndicator());
            } else if (state is VideosFetched) {
              return StreamBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.documents.length > 0) {
                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                          value: uploadBloc,
                                          child: VideoApp(
                                            user: user.uid,
                                            videoReference:
                                                snapshot.data.documents[index],
                                          ),
                                        )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 25.0),
                                child: Stack(children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Card(
                                      elevation: 5.0,
                                      child: CachedNetworkImage(
                                        imageUrl: "${snapshot.data.documents[index]['thumbnail']}",
                                        placeholder: (context,url)=>SizedBox(width: MediaQuery.of(context).size.width,height: 180,child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 150,vertical: 60),
                                          child: CircularProgressIndicator(),
                                        )),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 55,
                                      left: 150,
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 80.0,
                                        color: Colors.white,
                                      ))
                                ]),
                              ),
                            );
                          });
                    } else {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/please_upload.png',
                            width: 1300.0,
                            height: 130.0,
                          ),
                          Text("No Video Uploaded Yet",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold))
                        ],
                      ));
                    }
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                },
                stream: state.videos,
              );
            }
            return Container(
              child: Text(""),
            );
          },
        ),
      ),
      floatingActionButton: BlocListener<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadSuccess) {
            return Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                'Video Uploaded Successfully!',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
            ));
          } else if (state is UploadFailed) {
            return Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                'Video Uploading Aborted or Failed !',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
            ));
          }
        },
        child: BlocBuilder<UploadBloc, UploadState>(
          builder: (context, state) {
            if (state is UploadingState) {
              return CircularProgressIndicator();
            } else {
              return FloatingActionButton(
                child: Icon(Icons.file_upload),
                onPressed: () {
                  uploadBloc.add(UploadButtonPressed(uid: user.uid));
                },
                tooltip: "Upload Video",
              );
            }
          },
        ),
      ),
    );
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => LoginPageParent()));
  }
}
