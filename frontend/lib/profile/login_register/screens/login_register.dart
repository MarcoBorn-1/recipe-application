import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/custom_snack_bar.dart';
import 'package:frontend/common/widgets/title_text.dart';
import '../../../common/models/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerDisplayName = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (mounted) {
        showSnackBar(
          context, "Successfully logged in!", SnackBarType.success);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        displayName: _controllerDisplayName.text,
      );
      if (mounted) {
        showSnackBar(
          context, "Successfully registered account!", SnackBarType.success);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    if (isLogin) {
      return const Text('Login');
    } else {
      return const Text('Register');
    }
  }

  Widget _passwordTextField(String title, TextEditingController controller) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(color: Colors.red),
        helperStyle: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(color: Colors.red),
        helperStyle: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : '$errorMessage',
      style: const TextStyle(color: Colors.redAccent),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () async {
        isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
      },
      child: CustomButton(isLogin ? 'Login' : 'Register', true, 24),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          _controllerDisplayName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
          errorMessage = '';
        });
      },
      child: Text(
        isLogin ? 'Register instead' : 'Login instead',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title(),
          leading: const Icon(Icons.login, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF242424),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(isLogin ? "Login" : "Register"),
                _entryField('E-mail', _controllerEmail),
                (isLogin)
                    ? const Text("")
                    : _entryField('Username', _controllerDisplayName),
                _passwordTextField('Password', _controllerPassword),
                _errorMessage(),
                _submitButton(),
                _loginOrRegisterButton(),
              ],
            ),
          ),
        ));
  }
}
