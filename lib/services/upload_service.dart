import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class UploadService {
  StorageReference storageReference;

  Firestore _firestore = Firestore.instance;

  Future<bool> chooseFile(String uid) async {
    try {
      File file = await FilePicker.getFile(type: FileType.VIDEO);
      String fileExt = file.path.split('.').last;
      final String fileName = Random().nextInt(10000).toString() + '.$fileExt';
      final String fileUrl = await uploadFile(file, fileName);

      final imageThumbnail = await VideoThumbnail.thumbnailFile(
        video: file.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 200,
        quality: 75,
      );

      final String thumbnailUrl =
          await uploadThumbnail(imageThumbnail, fileName);

      DocumentReference checkStatus =
          await _firestore.collection('videos').add({
        'userId': uid,
        'fileUrl': fileUrl,
        'thumbnail': thumbnailUrl,
        'isLiked': [],
        'datetime': DateTime.now()
      });
      if (checkStatus != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String> uploadFile(File file, String filename) async {
    storageReference = FirebaseStorage.instance.ref().child("videos/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Future<String> uploadThumbnail(String file, String filename) async {
    storageReference =
        FirebaseStorage.instance.ref().child("thumbnail/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(File(file));
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Stream<QuerySnapshot> fetchVideos(userId) async* {
    yield* (_firestore
        .collection('videos')
        .where('userId', isEqualTo: userId)
        .snapshots());
  }

  Future<void> videoLiked(documentRef, String userId) async {
    documentRef = _firestore
        .collection('videos')
        .document(documentRef.documentID);

    bool checkisLiked = await 
        documentRef.get()
        .then((doc) {
      return (doc.data['isLiked'].contains(userId));
    });
    if (checkisLiked) {
      await documentRef
          .updateData({
        'isLiked': FieldValue.arrayRemove([userId]),
      });
    } else {
      await documentRef
          .updateData({
        'isLiked': FieldValue.arrayUnion([userId]),
      });
    }
  }
}
