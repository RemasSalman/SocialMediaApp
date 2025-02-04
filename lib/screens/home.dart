import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p8/provider/user_places.dart';

// Dummy Data
final List<Map<String, String>> dummyPosts = const [
  {
    "imageUrl":
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-8b388.firebasestorage.app/o/saudi%20arabia%20promotes%20ecommerce.jpg?alt=media&token=a5d0f54c-9efd-49cf-a69b-d79529735241",
    "caption": "Great ideas start here!",
    "author": "  Asma Muhanad",
    "userimage":
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-8b388.firebasestorage.app/o/user_images%2FLoluwah_Alnowaiser_3.jpg?alt=media&token=73d6780d-0457-4d6f-9284-40e1c8803da1",
  },
  {
    "imageUrl":
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-8b388.firebasestorage.app/o/51643ba7eab8ea0538000003.webp?alt=media&token=fda5f569-9ec6-4ad8-b523-0e6b2402cf25",
    "caption": "Building a brighter future!",
    "author": "  Ahamd Khaled",
    "userimage":
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-8b388.firebasestorage.app/o/user_images%2Fsaudi-character-sitting-working-using-260nw-2476402733.webp?alt=media&token=cafcc5a6-a304-4d50-b4d8-f0e51f13d33c",
  },
  {
    "imageUrl":
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-8b388.firebasestorage.app/o/MICE-Meeting_1.jpg?alt=media&token=ab272514-1da1-4557-a210-b0464e1487a5",
    "caption": "Collaboration in action",
    "author": "  Abdulaziz Fahad",
    "userimage":
        "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-8b388.firebasestorage.app/o/user_images%2Fistockphoto-1430206686-612x612.jpg?alt=media&token=c3ad36b3-f18f-4061-9fa3-8689b339e7af",
  },
];

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
                ],
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching user data"));
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("User not found"));
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final username = userData['username'] ?? 'No Name';
                final userImage = userData['image_url'] ?? '';

                final combinedPosts = <Map<String, dynamic>>[];

                for (var place in userPlaces) {
                  combinedPosts.add({
                    "image": place.image,
                    "title": place.title,
                    "author": "  $username",
                    "userimage": userImage,
                    "isLocal": true,
                  });
                }

                for (var post in dummyPosts) {
                  combinedPosts.add({
                    "imageUrl": post["imageUrl"],
                    "title": post["caption"],
                    "author": post["author"],
                    "userimage": post["userimage"],
                    "isLocal": false,
                  });
                }

                final filteredPosts = combinedPosts.where((post) {
                  return post["title"]!.toLowerCase().contains(searchQuery);
                }).toList();

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 19,
                        mainAxisSpacing: 50,
                        childAspectRatio:3/ 4,
                      ),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        final isLocal = post["isLocal"] as bool;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Image & Name
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: post["userimage"] != null &&
                                          post["userimage"]
                                              .toString()
                                              .isNotEmpty
                                      ? NetworkImage(post["userimage"]!)
                                      : const AssetImage(
                                              "assets/images/default_user.png")
                                          as ImageProvider,
                                  radius: 20,
                                  onBackgroundImageError:
                                      (exception, stackTrace) =>
                                          const Icon(Icons.error, size: 20),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  post["author"]!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // Post Image
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: isLocal
                                    ? Image.file(
                                        post["image"] as File,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : Image.network(
                                        post["imageUrl"]!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Title & Actions
                            Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      post["title"]!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(Icons.favorite_border),
                                    SizedBox(width: 10),
                                    Icon(Icons.more_horiz),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
