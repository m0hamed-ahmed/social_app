import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/social_layout.dart';
import 'package:social/modules/login/login_screen.dart';
import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data);
  showToast(message: 'On Background Message', toastState: ToastStates.success);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  await Firebase.initializeApp();

  userId = CacheHelper.getData(key: 'userId');

  Widget startWidget;
  if(userId == null) {startWidget = LoginScreen();}
  else {startWidget = SocialLayout();}
  
  String token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data);
    showToast(message: 'On Message', toastState: ToastStates.success);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data);
    showToast(message: 'On Message Opened App', toastState: ToastStates.success);
  });
  
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  BlocOverrides.runZoned(
      () => runApp(MyApp(startWidget: startWidget)),
      blocObserver: MyBlocObserver()
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({Key key, this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..getUserData()..getPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social App',
        theme: lightTheme,
        home: startWidget,
      ),
    );
  }
}