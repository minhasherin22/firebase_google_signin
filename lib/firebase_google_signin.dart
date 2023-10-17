import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly'
]);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MaterialApp(
    home: GoogleSign(),
  ));
}

class GoogleSign extends StatefulWidget {
  const GoogleSign({super.key});

  @override
  State<GoogleSign> createState() => _GoogleSignState();
}

class _GoogleSignState extends State<GoogleSign> {
  late GoogleSignInAccount currentUser;
  @override
  void initState() {
    //initially we want to check any user is here or not
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        currentUser = account!;
      });
      if (currentUser != null) {
        print('User is already authenticated');
      }
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: buildBody()),
    );
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print("sign in error: $e");
    }
  }

  Future<void> handleSignOut() async {
    await _googleSignIn.disconnect();
  }

  Widget buildBody(){
    GoogleSignInAccount user = currentUser;
    if(user != null){
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleUserCircleAvatar(identity: user),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                handleSignOut();
              }, child: Text("SIGN OUT")),
            ],
          ),
      );
    }else{
       return Center(
          child: ElevatedButton(onPressed: (){handleSignIn();}, child: Text("SIGN IN")),
       );
    }
  }
}
