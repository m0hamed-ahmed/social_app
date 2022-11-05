import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_layout.dart';
import 'package:social/modules/login/cubit/cubit.dart';
import 'package:social/modules/login/cubit/states.dart';
import 'package:social/modules/register/register_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();

  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is LoginErrorState) {
            showToast(message: state.error, toastState: ToastStates.error);
          }
          if(state is LoginSuccessState) {
            CacheHelper.setData(key: 'userId', value: state.userId).then((value) {
              navigateTo(context, SocialLayout(), true);
            });
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOGIN', style: TextStyle(color: defaultColor, fontSize: 50)),
                        const SizedBox(height: 15),
                        const Text('Login now to communicate with friends', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        const SizedBox(height: 30),
                        buildTextFormField(
                            textEditingController: textEditingControllerEmail,
                            textInputType: TextInputType.emailAddress,
                            labelText: 'Email Address',
                            prefixIcon: Icons.email_outlined,
                            validator: (val) {
                              if(val.isEmpty) {return 'Please enter your email address';}
                              return null;
                            }
                        ),
                        const SizedBox(height: 15),
                        buildTextFormField(
                            textEditingController: textEditingControllerPassword,
                            textInputType: TextInputType.visiblePassword,
                            labelText: 'Password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: cubit.obscureText,
                            suffixIcon: cubit.obscureText ? Icons.visibility : Icons.visibility_off,
                            suffixIconPressed: () => cubit.changeObscureText(),
                            validator: (val) {
                              if(val.isEmpty) {return 'Please enter your password';}
                              return null;
                            }
                        ),
                        const SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => buildButton(
                              onPressed: () {
                                if(formKey.currentState.validate()) {
                                  cubit.userLogin(
                                    email: textEditingControllerEmail.text,
                                    password: textEditingControllerPassword.text,
                                  );
                                }
                              },
                              text: 'LOGIN'
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            const SizedBox(width: 5),
                            TextButton(
                                onPressed: () {navigateTo(context, RegisterScreen(), false);},
                                child: Text('REGISTER NOW', style: TextStyle(color: defaultColor))
                            )
                          ],
                        ),
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
}