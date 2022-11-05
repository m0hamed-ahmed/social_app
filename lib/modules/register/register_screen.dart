import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_layout.dart';
import 'package:social/modules/register/cubit/cubit.dart';
import 'package:social/modules/register/cubit/states.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerPhone = TextEditingController();

  RegisterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is RegisterErrorState) {
            showToast(message: state.error, toastState: ToastStates.error);
          }
          else if(state is CreateUserErrorState) {
            showToast(message: state.error, toastState: ToastStates.error);
          }
          else if(state is CreateUserSuccessState) {
            CacheHelper.setData(key: 'userId', value: state.userId).then((value) {
              navigateTo(context, SocialLayout(), true);
            });
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REGISTER', style: TextStyle(color: defaultColor, fontSize: 50)),
                        const SizedBox(height: 15),
                        const Text('Register now to communicate with friends', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        const SizedBox(height: 30),
                        buildTextFormField(
                            textEditingController: textEditingControllerName,
                            textInputType: TextInputType.text,
                            labelText: 'User Name',
                            prefixIcon: Icons.person,
                            validator: (val) {
                              if(val.isEmpty) {return 'Please enter your name';}
                              return null;
                            }
                        ),
                        const SizedBox(height: 15),
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
                        const SizedBox(height: 15),
                        buildTextFormField(
                            textEditingController: textEditingControllerPhone,
                            textInputType: TextInputType.phone,
                            labelText: 'Phone',
                            prefixIcon: Icons.phone,
                            validator: (val) {
                              if(val.isEmpty) {return 'Please enter your phone';}
                              return null;
                            }
                        ),
                        const SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => buildButton(
                              onPressed: () {
                                if(formKey.currentState.validate()) {
                                  cubit.userRegister(
                                    name: textEditingControllerName.text,
                                    email: textEditingControllerEmail.text,
                                    password: textEditingControllerPassword.text,
                                    phone: textEditingControllerPhone.text,
                                  );
                                }
                              },
                              text: 'REGISTER'
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          );
        },
      ),
    );
  }
}