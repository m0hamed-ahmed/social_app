import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/shared/styles/colors.dart';

class NewPostScreen extends StatelessWidget {
  TextEditingController textEditingControllerPost = TextEditingController();

  NewPostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            titleSpacing: 5,
            actions: [
              TextButton(
                onPressed: () {
                  DateTime now = DateTime.now();
                  if(cubit.postImage == null) {
                    cubit.createPost(dateTime: now.toString(), text: textEditingControllerPost.text);
                  }
                  else {
                    cubit.uploadPostImage(dateTime: now.toString(), text: textEditingControllerPost.text);
                  }
                },
                child: Text('POST', style: TextStyle(color: defaultColor))
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if(state is SocialCreatePostLoadingState) const LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState) const SizedBox(height: 10),
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('https://img.freepik.com/free-photo/indecisive-girl-picks-from-two-choices-looks-questioned-troubled-crosses-hands-across-chest-hesitates-suggested-products-wears-yellow-t-shirt-isolated-crimson-wall_273609-42552.jpg?w=740&t=st=1649211074~exp=1649211674~hmac=20e8ae2398472584b4724e45317ebd56a399ddc60c178fd0e57a208b369bc696'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: Text('Mohamed Ahmed')
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textEditingControllerPost,
                    decoration: const InputDecoration(
                        hintText: 'what is on your mind ...',
                      border: InputBorder.none
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if(cubit.postImage != null) Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    IconButton(
                      onPressed: () => cubit.removePostImage(),
                      icon: const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.close, size: 16),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => cubit.getPostImage(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image),
                            SizedBox(width: 5),
                            Text('add photo')
                          ],
                        )
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: Text('# tags')
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}