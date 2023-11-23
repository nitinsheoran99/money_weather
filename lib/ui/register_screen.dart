import 'package:flutter/material.dart';
import 'package:money_weather/model/user_model.dart';
import 'package:money_weather/provider/auth_provider.dart';
import 'package:money_weather/util/login_widget.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, widget) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key:_formKey ,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: nameController,
                            hintText: 'Enter your name',

                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'email',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: emailController,
                            hintText: 'Enter your email',
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: passwordController,
                            obscureText: authProvider.isVisible ? false : true,
                            hintText: 'Enter your Password',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                authProvider.setPasswordFieldStatus();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Enter your Confirm Password',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: confirmPasswordController,
                            obscureText: authProvider.isVisible ? false : true,
                            hintText: 'Enter your Confirm Password',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  authProvider.setPasswordFieldStatus();
                                }

                              }
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()){
                                registerUser();}
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(24)),
                              child: const Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future registerUser() async {
    User user = User(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

    await provider.registerUser(user);

    if (mounted && provider.error == null) {
      Navigator.pop(context);
    }
  }
}
