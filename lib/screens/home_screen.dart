import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ivykids_assignment/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final nameController = TextEditingController();
  final contactController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    contactController.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference userDocRef = _users.doc(auth.currentUser!.uid);
    final CollectionReference contactsCollection =
        userDocRef.collection('contacts');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Contacts"),
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
                onTap: () {
                  auth
                      .signOut()
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen())))
                      .onError((error, stackTrace) => print(error.toString()));
                },
                child: const Icon(Icons.logout_outlined)),
          ],
        ),
        body: StreamBuilder(
          stream: contactsCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['contactNo']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  update(contactsCollection, documentSnapshot);
                                },
                                child: const Icon(Icons.edit)),
                            InkWell(
                                onTap: () {
                                  delete(
                                      contactsCollection, documentSnapshot.id);
                                },
                                child: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return const CircularProgressIndicator();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _alertBox(contactsCollection);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _alertBox(CollectionReference contacts) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Contact'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: contactController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Contact No.',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    contacts.add({
                      "name": nameController.text.toString(),
                      "contactNo": contactController.text.toString(),
                    });
                    Navigator.pop(context);
                    nameController.clear();
                    contactController.clear();
                  },
                  child: const Text('Add')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }

  Future<void> update(CollectionReference collectionReference,
      DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['name'].toString();
    contactController.text = documentSnapshot['contactNo'].toString();
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Contact'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: contactController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Contact No.',
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final String name = nameController.text.toString();
                    final String contact = contactController.text.toString();
                    await collectionReference
                        .doc(documentSnapshot.id)
                        .update({"contactNo": contact, "name": name});
                    Navigator.pop(context);
                    nameController.clear();
                    contactController.clear();
                  },
                  child: const Text('Update')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }

  Future<void> delete(
      CollectionReference collectionReference, String id) async {
    await collectionReference.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contact was successfully deleted")));
  }
}
