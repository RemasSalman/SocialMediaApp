import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMassage extends StatefulWidget {
  const NewMassage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMassageState();
  }
}

class _NewMassageState extends State<NewMassage> {
  final _messageControler = TextEditingController();

  @override
  void dispose() {
    _messageControler.dispose();
    super.dispose();
  }

  void _submited() async {
    final enterdMessage = _messageControler.text;

    if (enterdMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageControler.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enterdMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 70),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageControler,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(
              labelText: 'Send a message ...',
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20), // Adjust the content padding for height
              fillColor: const Color.fromARGB(
                  28, 96, 125, 139), // Set the background color to gray
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              suffixIcon: IconButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: _submited,
                splashColor: Colors.lightBlueAccent,
                icon: Icon(Icons.send_rounded,
                    color: Color.fromRGBO(9, 52, 128, 1)),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
