import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.submitFn2,
    this.isLoading,
  );
  final void Function(
    BuildContext ctx,
  ) submitFn2;
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit(bool key) {
    if (key) {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      if (_userImageFile == null && !_isLogin) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Please pick an image.'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }

      if (isValid) {
        _formKey.currentState.save();
        widget.submitFn(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _userImageFile,
          _isLogin,
          context,
        );
        _autoValidate = false;
      } else {
        _autoValidate = true;
      }
    } else {
      widget.submitFn2(context);
    }
  }

  Widget _signInButton() {
    return RaisedButton(
      color: Colors.white,
      splashColor: Colors.grey,
      onPressed: () => _trySubmit(false),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      // highlightElevation: 0,
      // borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || !_validateEmail(value.trim())) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: () => _trySubmit(true),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                  if (!widget.isLoading)
                    Text(
                      'or',
                    ),
                  if (!widget.isLoading)
                    SizedBox(
                      height: 3,
                    ),
                  if (!widget.isLoading) _signInButton(),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
