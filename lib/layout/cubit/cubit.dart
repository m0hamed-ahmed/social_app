import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/chats/chats_screen.dart';
import 'package:social/modules/feeds/feeds_screen.dart';
import 'package:social/modules/new_post/new_post_screen.dart';
import 'package:social/modules/settings/settings_screen.dart';
import 'package:social/modules/users/users_screen.dart';
import 'package:social/shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel userModel;
  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen()
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings'
  ];
  File profileImage;
  File coverImage;
  File postImage;
  ImagePicker imagePicker = ImagePicker();
  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<UserModel> users = [];
  List<MessageModel> messages = [];

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  void getPosts() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {

        });
      });
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void changeBottomNavBa(int index) {
    if(index == 1) {
      getUsers();
    }
    if(index == 2) {
      emit(SocialNewPostState());
    }
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavBarState());
    }
  }

  Future<void> getProfileImage() async {
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    }
    else {
      emit(SocialProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }
    else {
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({String name, String phone, String bio}) {
    emit(SocialUpdateUserLoadingState());
    FirebaseStorage.instance.ref().child('users').child(Uri.file(profileImage.path).pathSegments.last).putFile(profileImage).then((val) {
      val.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, image: value);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
    profileImage = null;
  }

  void uploadCoverImage({String name, String phone, String bio}) {
    emit(SocialUpdateUserLoadingState());
    FirebaseStorage.instance.ref().child('users').child(Uri.file(coverImage.path).pathSegments.last).putFile(coverImage).then((val) {
      val.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
    coverImage = null;
  }

  void updateUser({String name, String phone, String bio, String image, String cover}) {
    UserModel model = UserModel(
        name: name,
        phone: phone,
        bio: bio,
        image: image??userModel.image,
        cover: cover??userModel.cover,
        email: userModel.email,
        password: userModel.password,
        isEmailVerified: userModel.isEmailVerified,
        userId: userModel.userId
    );
    FirebaseFirestore.instance.collection('users').doc(userId).update(model.toMap()).then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }

  void uploadPostImage({String dateTime, String text}) {
    emit(SocialCreatePostLoadingState());
    FirebaseStorage.instance.ref().child('posts').child(Uri.file(postImage.path).pathSegments.last).putFile(postImage).then((val) {
      val.ref.getDownloadURL().then((value) {
        createPost(text: text, dateTime: dateTime, postImage: value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
    postImage = null;
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  Future<void> getPostImage() async {
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    }
    else {
      emit(SocialPostImagePickedErrorState());
    }
  }

  void createPost({String dateTime, String text, String postImage}) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      userId: userModel.userId,
      name: userModel.name,
      image: userModel.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage?? ''
    );
    FirebaseFirestore.instance.collection('posts').add(model.toMap()).then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(userModel.userId).set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void getUsers() {
    if(users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if(element.data()['uid'] != userModel.userId) {
            users.add(UserModel.fromJson(element.data()));
          }
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage({String receiverId, String dateTime, String text}) {
    MessageModel model = MessageModel(
      senderId: userModel.userId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text
    );

    FirebaseFirestore.instance.collection('users').doc(userModel.userId).collection('chats').doc(receiverId).collection('messages').add(model.toMap()).then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance.collection('users').doc(receiverId).collection('chats').doc(userModel.userId).collection('messages').add(model.toMap()).then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  void getMessages({String receiverId}) {
    FirebaseFirestore.instance.collection('users').doc(userModel.userId).collection('chats').doc(receiverId).collection('messages').orderBy('dateTime').snapshots().listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
        emit(SocialGetMessagesSuccessState());
      });
    });
  }
}