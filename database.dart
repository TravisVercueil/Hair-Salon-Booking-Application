import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_haircutters/user.dart';
import 'package:the_haircutters/currentUser.dart';

class OurDatabase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async{
    String retVal = "error";

    try{
      await _firestore.collection("users").doc(user.uid).set({
        'fullName' : user.fullName,
        'email' : user.email,

      });
      retVal = "success";
    }catch(e){
      print(e);

    }
    return retVal;
  }

}