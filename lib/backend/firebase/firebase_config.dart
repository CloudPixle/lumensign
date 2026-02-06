import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCHqPpZAaQ9enFTvqEJwm8MvS0pAyECJ9s",
            authDomain: "lumen-bvv207.firebaseapp.com",
            projectId: "lumen-bvv207",
            storageBucket: "lumen-bvv207.firebasestorage.app",
            messagingSenderId: "518274292884",
            appId: "1:518274292884:web:daf6b5254c313f58f4e881"));
  } else {
    await Firebase.initializeApp();
  }
}
