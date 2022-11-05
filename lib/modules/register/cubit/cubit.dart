import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool obscureText = true;

  void userRegister({String name, String email, String password, String phone}) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      userCreate(userId: value.user.uid, name: name, email: email, password: password, phone: phone);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({String userId, String name, String email, String password, String phone}) {
    UserModel userModel = UserModel(
      userId: userId,
      name: name,
      email: email,
      password: password,
      phone: phone,
      isEmailVerified: false,
      bio: 'write your bio ...',
      image: 'https://herrmans.eu/wp-content/uploads/2019/01/765-default-avatar.png',
      cover: 'https://img.freepik.com/free-photo/positive-african-american-girl-points-thumb-demonstrates-copy-space-blank-pink-wall-has-happy-friendly-expression-dressed-casually-poses-indoor-suggests-going-right-says-follow-this-direction_273609-42167.jpg?w=740'
    );
    FirebaseFirestore.instance.collection('users').doc(userId).set(userModel.toMap()).then((value) {
      emit(CreateUserSuccessState(userId));
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  changeObscureText() {
    obscureText = !obscureText;
    emit(RegisterChangeObscureTextState());
  }
}