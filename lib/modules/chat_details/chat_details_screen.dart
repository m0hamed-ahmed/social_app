import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/styles/colors.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;
  TextEditingController textEditingControllerMessage = TextEditingController();

  ChatDetailsScreen({Key key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.userId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is SocialSendMessageSuccessState) {
              textEditingControllerMessage.text = '';
            }
          },
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userModel.image),
                    ),
                    const SizedBox(width: 15),
                    Text(userModel.name)
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: cubit.messages.isNotEmpty,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if(cubit.userModel.userId == cubit.messages[index].senderId) {
                              return buildMyMessage(cubit.messages[index]);
                            }
                            return buildMessage(cubit.messages[index]);
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          itemCount: cubit.messages.length
                        ),
                      ),
                      Container(
                        height: 50,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300], width: 1),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: textEditingControllerMessage,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here ...',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10)
                                ),
                              ),
                            ),
                            Container(
                              color: defaultColor,
                              child: MaterialButton(
                                onPressed:  () {
                                  cubit.sendMessage(
                                      receiverId: userModel.userId,
                                      dateTime: DateTime.now().toString(),
                                      text: textEditingControllerMessage.text
                                  );
                                },
                                minWidth: 1,
                                child: const Icon(Icons.send, size: 16, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                fallback: (context) => const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomEnd: Radius.circular(10),
          )
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(model.text),
    ),
  );

  Widget buildMyMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
          color: defaultColor.withOpacity(0.2),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomStart: Radius.circular(10),
          )
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(model.text),
    ),
  );
}
