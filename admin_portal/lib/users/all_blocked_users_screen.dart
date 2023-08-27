import 'package:admin_portal/main_screens/home_screen.dart';
import 'package:admin_portal/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllBlockedUsersScreen extends StatefulWidget {
  const AllBlockedUsersScreen({super.key});

  @override
  State<AllBlockedUsersScreen> createState() => _AllBlockedUsersScreenState();
}

class _AllBlockedUsersScreenState extends State<AllBlockedUsersScreen> {
  QuerySnapshot? allUsers;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allUsers = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    displayDialogBoxForActivatingAccount(userDocumentId) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Activate Account",
                style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Do you want to activate the account?",
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> userDataMap = {
                      "status": "approved",
                    };
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(userDocumentId)
                        .update(userDataMap)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const HomeScreen()));
                      SnackBar snackBar = const SnackBar(
                        content: Text(
                          "User Activated Successfully.",
                          style: TextStyle(fontSize: 36),
                        ),
                        backgroundColor: Colors.pink,
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                  child: const Text("Yes"),
                )
              ],
            );
          });
    }

    displayNonVerifiedUsersDesign() {
      if (allUsers != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: allUsers!.docs.length,
          itemBuilder: (context, i) {
            return Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                allUsers!.docs[i].get("photoUrl"),
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                      title: Text(
                        allUsers!.docs[i].get("name"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.email,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            allUsers!.docs[i].get("email"),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        displayDialogBoxForActivatingAccount(
                            allUsers!.docs[i].id);
                      },
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Activate This Account".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 15,
                            letterSpacing: 3,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        return const Center(
          child: Text("No records found"),
        );
      }
    }

    return Scaffold(
      appBar: SimpleAppBar(
        title: "All Blocked User Accounts",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: displayNonVerifiedUsersDesign(),
        ),
      ),
    );
  }
}
