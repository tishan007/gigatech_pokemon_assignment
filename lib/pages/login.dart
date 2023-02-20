import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gigatech_pokemon/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:system_settings/system_settings.dart';
import 'dart:async';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _checked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if ((_connectionStatus.toString().contains("none"))) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
            content: const Text(
              "Please Check Your Internet",
              style:
              TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Go to Settings'),
                onPressed: () {
                  SystemSettings.system();
                },
              ),
              TextButton(
                child: const Text('Close me!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: _buildSignInBody(),
    );
  }

  _buildSignInBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 90,),
              Image.asset('assets/logo.png', width: 48, height: 48,),
              const SizedBox(height: 20,),
              const Text("Sign In", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'),),
              const SizedBox(height: 5,),
              const Text("Welcome back! Please enter your details.", style: TextStyle(fontSize: 16, fontFamily: 'Inter'),),
              const SizedBox(height: 25,),
              const Text("Email", style: TextStyle(fontSize: 14, fontFamily: 'Inter'),),
              const SizedBox(height: 5,),
              TextFormField(
                autofocus: false,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(fontFamily: 'Inter'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Text("Password", style: TextStyle(fontSize: 14, fontFamily: 'Inter'),),
              const SizedBox(height: 5,),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordController,
                obscureText: true,   //This will obscure text dynamically
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(fontFamily: 'Inter'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  /*suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey,),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),*/
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: _checked,
                          onChanged:(bool? value) {
                            setState(() {
                              _checked = value!;
                            });
                          },
                        ),
                        const Text('Remember for 30 days', style: TextStyle(fontSize: 14, fontFamily: 'Inter'),)
                      ],
                    ),

                    const Text('Forgot password', style: TextStyle(fontSize: 14, color: Color(0xFF6941C6), fontWeight: FontWeight.w600, fontFamily: 'Inter'),),
              ]),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("email", _emailController.text);
                    Utils.successToast("Login Successfully");
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    Utils.errorToast("Please enter email & password");
                  }
                },
                child: Text("Sign In", style: TextStyle(fontFamily: 'Inter', fontSize: 16),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(349, 58),
                  backgroundColor: const Color(0xFF6941C6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: const TextSpan(text: "Don’t have an account? ", style: TextStyle(fontSize: 14, color: Color(0xFF475467), fontWeight: FontWeight.w500, fontFamily: 'Inter'),
                      children: <TextSpan>[
                        TextSpan(text: " Sign up", style: TextStyle(fontSize: 14, color: Color(0xFF6941C6), fontWeight: FontWeight.w500, fontFamily: 'Inter'),),
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Image.asset('assets/Line.png'),
              ),

            ],
          ),
        )
      ],
    );
  }

}
