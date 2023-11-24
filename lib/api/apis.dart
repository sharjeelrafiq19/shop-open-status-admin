import 'package:cloud_firestore/cloud_firestore.dart';

class APIs {
  static Future<void> setShopStatus(bool open) async {
    try {
      FirebaseFirestore.instance
          .collection('shop')
          .doc("status") // <-- Document ID
          .set({"open": open}) // <-- Your data
          .then((_) => print('Added'))
          .catchError((error) => print('Add failed: $error'));
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future<bool> getShopStatus() async {
    bool isShopOpen = false;
    try {
      await FirebaseFirestore.instance
          .collection('shop')
          .doc("status")
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();
          isShopOpen = data?['open'];
        }
      });
    } catch (e) {
      print("Error: $e");
    }
    return isShopOpen;
  }
}
