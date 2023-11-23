import 'package:flutter/material.dart';
import 'package:money_weather/model/user_model.dart';
import 'package:money_weather/provider/auth_provider.dart';
import 'package:money_weather/ui/register_screen.dart';
import 'package:money_weather/util/login_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, widget) {
          return Center(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Login app to continue',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            AppTextField(
                              controller: emailController,
                              hintText: 'Enter your Email',
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
                                obscureText:
                                authProvider.isVisible ? false : true,
                                hintText: 'Enter your Password',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    authProvider.setPasswordFieldStatus();
                                  },
                                )),
                            const SizedBox(
                              height: 24,
                            ),
                            InkWell(
                              onTap: () {
                                loginUser();
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(24)),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have account"),
                                const SizedBox(
                                  width: 4,
                                ),
                                TextButton(
                                    onPressed: () {
                                      openRegisterUserScreen();
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(color: Colors.blue),
                                    )),
                              ],
                            )
                          ],
                        ),
                        Positioned(
                            child: authProvider.isLoading
                                ? const CircularProgressIndicator()
                                : const SizedBox())
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openRegisterUserScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterScreen();
    }));
  }

  Future loginUser() async {
    User user = User(
      email: emailController.text,
      password: passwordController.text,
    );

    AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);
    bool isExist = await authProvider.isUserExists(user);
    if (isExist && mounted) {
    }
  }
}
