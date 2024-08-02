// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/provider/auth_provider.dart';
import 'package:job_search/infrastructure/provider/provider_registration.dart';
import 'package:job_search/ui/screens/home_screen/employer_home_screen.dart';
import 'package:job_search/ui/screens/home_screen/jobseeker_home_screen.dart';
import 'package:job_search/ui/screens/login_screen/login_screen.dart';
import 'package:job_search/ui/widgets/common_auth_buttons.dart';
import 'package:job_search/ui/widgets/common_snack_bar.dart';

import '../../widgets/common_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProviderRead = ref.read(authProvider);
    final authProviderWatch = ref.watch(authProvider);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 2.8,
                  child: Image.asset('assets/images/signup.jpeg'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRoleButton(
                      containerColor: authProviderWatch.selectedRole == 0
                          ? Colors.blue.withOpacity(.5)
                          : Colors.white.withOpacity(.6),
                      title: 'Employer',
                      onTap: () => authProviderRead.changeRoleSelection(0),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    buildRoleButton(
                      containerColor: authProviderWatch.selectedRole == 1
                          ? Colors.blue.withOpacity(.5)
                          : Colors.white.withOpacity(.6),
                      title: 'JobSeeker',
                      onTap: () => authProviderRead.changeRoleSelection(1),
                    ),
                  ],
                ),
                TextFieldInput(
                    icon: Icons.person,
                    textEditingController: nameController,
                    hintText: 'Enter your name',
                    textInputType: TextInputType.text),
                TextFieldInput(
                    icon: Icons.email,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.text),
                TextFieldInput(
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                CommonAuthButton(onTap: signUpUser, text: "Sign Up"),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget buildRoleButton(
      {required Color containerColor,
      required String title,
      void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: containerColor,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }

  void signUpUser() async {
    // set is loading to true.
    ref.watch(authProvider).setIsLoading(true);

    // signup user using our auth method
    String response = await ref.read(authProvider).signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        role: ref.watch(authProvider).selectedRole);

    // if string return is success, user has been created and navigate to next screen other wise show error.
    if (response == "success") {
      ref.watch(authProvider).setIsLoading(false);
      //navigate to the next screen
      if (ref.watch(authProvider).selectedRole == 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const EmployerHomeScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const JobseekerHomeScreen(),
          ),
        );
      }
    } else {
      ref.watch(authProvider).setIsLoading(false);

      // show error
      showSnackBar(context, response);
    }
  }
}
