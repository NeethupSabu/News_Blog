import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one/Screens/BookmarkPge.dart';
import 'package:one/Screens/CreateNewArticle.dart';
import 'package:one/Screens/HomeScreen.dart';
import 'package:one/Screens/Membership.dart';
import 'package:one/Screens/Profil.dart';
import 'package:one/Screens/Settings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['name'] ?? 'User';
          final profilePicUrl =
              userData['profilePic'] ?? 'assets/placeholder.png';

          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                child: SizedBox(
                  //color: Colors.grey[200], // Background color for the header
                  height: 130, // Adjust the height as needed
                  child: DrawerHeader(
                    margin: EdgeInsets.zero, // Remove default margin
                    padding: const EdgeInsets.all(
                        8), // Add padding inside the header
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40, // Adjust radius as needed
                          backgroundImage: NetworkImage(profilePicUrl),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 30.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 90.0),
                              child: Column(
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          20, // Adjust font size as needed
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // overflow:
                                    //     TextOverflow.ellipsis, // Handle overflow
                                  ),
                                  const Text(
                                    'View Profile',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          12, // Adjust font size as needed
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // Handle overflow
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text('home'.tr()),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                visualDensity: const VisualDensity(
                    horizontal: 0, vertical: -4), // Localized text
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text('create_new_article'.tr()),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                visualDensity: const VisualDensity(
                    horizontal: 0, vertical: -4), // Localized text
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateNewArticlePage()),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text('bookmark'.tr()),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                visualDensity: const VisualDensity(
                    horizontal: 0, vertical: -4), // Localized text
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookmarkPage()),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text('membership'.tr()),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                visualDensity: const VisualDensity(
                    horizontal: 0, vertical: -4), // Localized text
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MembershipPlanPage()),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text('settings'.tr()),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                visualDensity: const VisualDensity(
                    horizontal: 0, vertical: -4), // Localized text
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:one/Screens/BookmarkPge.dart';
// import 'package:one/Screens/CreateNewArticle.dart';
// import 'package:one/Screens/HomeScreen.dart';
// import 'package:one/Screens/Membership.dart';
// import 'package:one/Screens/Settings.dart';

// class MyDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final User? user = FirebaseAuth.instance.currentUser;

//     return Drawer(
//       child: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user?.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('No user data found'));
//           }

//           final userData = snapshot.data!.data() as Map<String, dynamic>;
//           final userName = userData['name'] ?? 'User';
//           final profilePicUrl =
//               userData['profilePic'] ?? 'assets/placeholder.png';

//           return ListView(
//             padding: EdgeInsets.zero,
//             children: <Widget>[
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                     // color: Colors.blue, // Customize the color
//                     ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: NetworkImage(profilePicUrl),
//                       backgroundColor: Colors.grey,
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       userName,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Home'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const HomePage()),
//                   );
//                 },
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 10, right: 10),
//                 child: Divider(
//                   thickness: 2,
//                   color: Colors.black,
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Create New Article'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const CreateNewArticlePage()),
//                   );
//                 },
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 10, right: 10),
//                 child: Divider(
//                   thickness: 2,
//                   color: Colors.black,
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Bookmark'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const BookmarkPage()),
//                   );
//                 },
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 10, right: 10),
//                 child: Divider(
//                   thickness: 2,
//                   color: Colors.black,
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Membership'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const MembershipPlanPage()),
//                   );
//                 },
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 10, right: 10),
//                 child: Divider(
//                   thickness: 2,
//                   color: Colors.black,
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Settings'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SettingsPage()),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
