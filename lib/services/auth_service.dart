

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  
    FirebaseAuth firebaseAuth;
    
    AuthService(){
      this.firebaseAuth = FirebaseAuth.instance;
    }

    Future<FirebaseUser> signInUser(String email,String password) async{
      var result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;

    }

    Future<void> signOut()async{
      await firebaseAuth.signOut();
    }

    Future<bool> isSignedIn()async{
      var currentUser = await firebaseAuth.currentUser();
      return currentUser != null;
    }

    Future<FirebaseUser> getCurrentUser() async{
      return await firebaseAuth.currentUser();
    }


}