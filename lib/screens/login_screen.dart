import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/services/shared_preference_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isButtonVisible = false;
  bool _isLoading = false;

  void _toggleButtonVisibility() {
    final content = _emailController.text;
    if (content.isNotEmpty) {
      if (!_isButtonVisible) {
        setState(() => _isButtonVisible = true);
      }
    } else {
      setState(() => _isButtonVisible = false);
    }
  }

  Future<void> _authenticate() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);

      final email = _emailController.text;
      final SharedPreferencesService pref =
          await SharedPreferencesService.getInstance();

      if (!context.mounted) return;

      pref.saveData('email', email);
      pref.saveData('is_login', true);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_toggleButtonVisibility);
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Enter your email address'),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "example@mail.domain",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _isButtonVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _authenticate();
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Continue'),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
