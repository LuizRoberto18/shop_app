import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;
  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };
  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    );
    // _heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }

  bool _isLogin() => _authMode == AuthMode.login;

  //bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Ocorreu um Erro",
            style: TextStyle(color: Colors.black),
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);
    try {
      if (_isLogin()) {
        //login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        //registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro desconhecido!");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        // height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData["email"] = email ?? "",
                validator: (newEmail) {
                  final email = newEmail ?? "";
                  if (email.trim().isEmpty || !email.contains("@")) {
                    return "Informe um email valido";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Senha",
                ),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                onSaved: (password) => _authData["password"] = password ?? "",
                validator: (newPassword) {
                  final password = newPassword ?? "";
                  if (password.isEmpty || password.length < 5) {
                    return "Informe uma senha valida";
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Confirmar Senha",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (newConfiPassword) {
                              final password = newConfiPassword ?? "";
                              if (password != _passwordController.text) {
                                return "Senhas informadas n??o conferem";
                              }
                              return null;
                            },
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    _authMode == AuthMode.login ? "Entrar".toUpperCase() : "Resgistrar".toUpperCase(),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? "deseja registrar?".toUpperCase() : "J?? possui conta?".toUpperCase(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
