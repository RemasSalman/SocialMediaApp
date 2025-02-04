import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p8/screens/chat.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data found."));
          }

          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.only(
                  top: 36,
                ),
                child: Material(
                  color: const Color.fromARGB(3, 22, 47, 67),
                  borderRadius: BorderRadius.circular(25),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(documentSnapshot['username'] ?? 'No Name'),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              documentSnapshot['image_url'] ?? 'No image'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                           
                            IconButton(
                              icon: Icon(
                                Icons.chat_bubble_outline_outlined,
                                color: const Color.fromARGB(98, 0, 0, 0),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) =>
                                      ChatScreen(), // Navigate to ChatScreen
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
