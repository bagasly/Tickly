import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import 'package:tickly/screen/login.dart';
import 'package:tickly/service/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuVisible = false;

  late Stream<QuerySnapshot> categoryStream;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCategoryDetails();
  }

  Future<void> getCategoryDetails() async {
    setState(() {
      categoryStream =
          FirebaseFirestore.instance.collection("categories").snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundImage: NetworkImage(user?.photoURL ?? ""),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ohayou!',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        user?.displayName ?? "",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(0),
              child: TextField(
                style: const TextStyle(fontSize: 14),
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF0F1F2),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'Cari...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              "Kategori",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onLongPress: () {
                setState(() {
                  _isMenuVisible = true;
                });
              },
              onTap: () {
                setState(() {
                  _isMenuVisible = false;
                });
              },
              child: StreamBuilder<QuerySnapshot>(
                stream: categoryStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        var categoryName = document['name'];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _isMenuVisible
                                ? Colors.grey[300]
                                : const Color(0xffF0F1F2),
                            boxShadow: _isMenuVisible
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: ListTile(
                            title: Text(
                              categoryName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              onPressed: () {
                                // Logika ketika tugas selesai ditandai
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
            ),
            if (_isMenuVisible)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isMenuVisible ? 1.0 : 0.0,
                child: AnimatedContainer(
                  margin: const EdgeInsets.only(left: 220),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                      vertical: _isMenuVisible ? 10 : 0, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Pin pressed');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Pin',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.push_pin, color: Colors.blue),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          print('Edit pressed');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Edit',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.edit, color: Colors.orange),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          print('Delete pressed');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.delete, color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Nama kategori',
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  String categoryName = nameController.text;
                                  if (categoryName.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                              'Nama kategori tidak boleh kosong.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    String userId =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    String categoryId = randomAlphaNumeric(10);
                                    Map<String, dynamic> categoryData = {
                                      "name": categoryName,
                                      "userId": userId,
                                      "categoryId": categoryId,
                                    };
                                    await DatabaseMethods()
                                        .addCategory(categoryData, categoryId)
                                        .then((value) {
                                      Fluttertoast.showToast(
                                        msg: "Kategori berhasil ditambahkan",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16,
                                      );
                                      Navigator.pop(context);
                                      nameController.clear();
                                    });
                                  }
                                },
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(color: Color(0xff2399EE)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            backgroundColor: const Color(0xff5780F6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () async {
              GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    ),
                  );
            },
            backgroundColor: const Color(0xff5780F6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}