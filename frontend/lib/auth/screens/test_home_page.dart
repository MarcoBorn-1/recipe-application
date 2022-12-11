import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/auth/widgets/auth.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        //onPressed: signOut,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Go back'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      // onPressed: () {Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const TestPage()),
      // );
      // },
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("title"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            ElevatedButton(
              //onPressed: signOut,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TestPage()),
                );
              },
              child: const Text('Test page'),
            ),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
