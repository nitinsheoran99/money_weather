import 'package:flutter/material.dart';
import 'package:money_weather/dashboard/ui/dashboard_screen.dart';
import 'package:money_weather/login/model/user_model.dart';
import 'package:money_weather/login/provider/auth_provider.dart';
import 'package:money_weather/login/ui/register_screen.dart';
import 'package:money_weather/login/util/app_string.dart';
import 'package:money_weather/login/util/login_widget.dart';

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
                              login,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              loginText,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              email,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            AppTextField(
                              controller: emailController,
                              hintText: emailFieldHint,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              password,
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
                                hintText: passwordFieldHint,
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
                                  login,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(noAccount),
                                const SizedBox(
                                  width: 4,
                                ),
                                TextButton(
                                    onPressed: () {
                                      openRegisterUserScreen();
                                    },
                                    child: const Text(
                                      register,
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
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return  DashboardScreen(
        );
      }),);
    }
  }
}
