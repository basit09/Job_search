
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/provider/provider_registration.dart';
import 'package:job_search/ui/screens/home_screen/employer_home_screen.dart';
import 'package:job_search/ui/screens/home_screen/jobseeker_home_screen.dart';
import 'package:job_search/ui/screens/sign_up_screen/sign_up_screen.dart';
import 'package:job_search/ui/widgets/common_auth_buttons.dart';
import 'package:job_search/ui/widgets/common_snack_bar.dart';
import 'package:job_search/ui/widgets/common_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// email and password auth part
  void loginUser() async {
    ref.read(authProvider).setIsLoading(true);

    // signup user using our auth method
    String res = await ref.read(authProvider).loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      ref.read(authProvider).setIsLoading(false);
      navigateOnRole();
    } else {
      ref.read(authProvider).setIsLoading(false);

      // show error
      showSnackBar(context, res);
    }
  }

  void navigateOnRole() {
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
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 2.7,
                child: Image.asset('assets/images/login.jpg'),
              ),
              TextFieldInput(
                  icon: Icons.person,
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
              //  we call our forgot password below the login in button
              // const ForgotPassword(),
              CommonAuthButton(onTap: loginUser, text: "Log In"),

              // Don't have an account? got to signup screen
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black45,
          width: 2,
        ),
      ),
      child: Image.network(
        image,
        height: 40,
      ),
    );
  }
}
