import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerBio = TextEditingController();
  TextEditingController textEditingControllerPhone = TextEditingController();

  EditProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        textEditingControllerName.text = cubit.userModel.name;
        textEditingControllerBio.text = cubit.userModel.bio;
        textEditingControllerPhone.text = cubit.userModel.phone;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            titleSpacing: 5,
            actions: [
              TextButton(
                  onPressed: () {
                    if(formKey.currentState.validate()) {
                      cubit.updateUser(
                        name: textEditingControllerName.text,
                        bio: textEditingControllerBio.text,
                        phone: textEditingControllerPhone.text
                      );
                    }
                  },
                  child: const Text('Update')
              ),
              const SizedBox(width: 10)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(state is SocialUpdateUserLoadingState) const LinearProgressIndicator(),
                    if(state is SocialUpdateUserLoadingState) const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 140,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                      image: DecorationImage(
                                        image: cubit.coverImage == null ? NetworkImage(cubit.userModel.cover) : FileImage(cubit.coverImage),
                                        fit: BoxFit.cover,
                                      )
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => cubit.getCoverImage(),
                                  icon: const CircleAvatar(
                                    radius: 20,
                                    child: Icon(Icons.camera_alt, size: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: cubit.profileImage == null ? NetworkImage(cubit.userModel.image) : FileImage(cubit.profileImage),
                                ),
                              ),
                              IconButton(
                                onPressed: () => cubit.getProfileImage(),
                                icon: const CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.camera_alt, size: 16),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if(cubit.profileImage != null || cubit.coverImage != null) Row(
                      children: [
                        if(cubit.profileImage != null) Expanded(
                          child: Column(
                            children: [
                              buildButton(
                                onPressed: () => cubit.uploadProfileImage(
                                  name: textEditingControllerName.text,
                                  bio: textEditingControllerBio.text,
                                  phone: textEditingControllerPhone.text,
                                ),
                                text: 'Upload Profile'
                              ),
                              if(state is SocialUpdateUserLoadingState) const SizedBox(height: 5),
                              if(state is SocialUpdateUserLoadingState) const LinearProgressIndicator()
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        if(cubit.coverImage != null) Expanded(
                          child: Column(
                            children: [
                              buildButton(
                                onPressed: () => cubit.uploadCoverImage(
                                  name: textEditingControllerName.text,
                                  bio: textEditingControllerBio.text,
                                  phone: textEditingControllerPhone.text,
                                ),
                                text: 'Upload Cover'
                              ),
                              if(state is SocialUpdateUserLoadingState) const SizedBox(height: 5),
                              if(state is SocialUpdateUserLoadingState) const LinearProgressIndicator()
                            ],
                          ),
                        )
                      ],
                    ),
                    if(cubit.profileImage != null || cubit.coverImage != null) const SizedBox(height: 20),
                    buildTextFormField(
                      textEditingController: textEditingControllerName,
                      textInputType: TextInputType.text,
                      labelText: 'Name',
                      validator: (val) {
                        if(val.isEmpty) {return 'Name must not be empty';}
                        return null;
                      },
                      prefixIcon: Icons.person_outline
                    ),
                    const SizedBox(height: 15),
                    buildTextFormField(
                      textEditingController: textEditingControllerBio,
                      textInputType: TextInputType.text,
                      labelText: 'Bio',
                      validator: (val) {
                        if(val.isEmpty) {return 'Bio must not be empty';}
                        return null;
                      },
                      prefixIcon: Icons.info_outline
                    ),
                    const SizedBox(height: 15),
                    buildTextFormField(
                      textEditingController: textEditingControllerPhone,
                      textInputType: TextInputType.phone,
                      labelText: 'Phone',
                      validator: (val) {
                        if(val.isEmpty) {return 'Phone number must not be empty';}
                        return null;
                      },
                      prefixIcon: Icons.phone
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}