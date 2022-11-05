import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/states.dart';
import 'package:social/models/post_model.dart';
import 'package:social/shared/styles/colors.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty && cubit.userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  margin: const EdgeInsets.all(8),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: const [
                      Image(
                        image: NetworkImage('https://img.freepik.com/free-photo/positive-african-american-girl-points-thumb-demonstrates-copy-space-blank-pink-wall-has-happy-friendly-expression-dressed-casually-poses-indoor-suggests-going-right-says-follow-this-direction_273609-42167.jpg?w=740'),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Communicate With Friends', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildPostItem(context, cubit.posts[index], index),
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemCount: cubit.posts.length,
                ),
                const SizedBox(height: 8)
              ],
            ),
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(BuildContext context, PostModel postModel, int index) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(postModel.image),
              ),
              const SizedBox(width: 15),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(postModel.name),
                          const SizedBox(width: 5),
                          Icon(Icons.check_circle, color: defaultColor, size: 16)
                        ],
                      ),
                      Text(postModel.dateTime, style: Theme.of(context).textTheme.caption),
                    ],
                  )
              ),
              const SizedBox(width: 15),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz, size: 16)
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Text(postModel.text),
          if(false) Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 3,
                children: [
                  SizedBox(
                    height: 25,
                    child: MaterialButton(
                        minWidth: 1,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Text('#software', style: Theme.of(context).textTheme.caption.copyWith(color: defaultColor))
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: MaterialButton(
                        minWidth: 1,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: Text('#flutter', style: Theme.of(context).textTheme.caption.copyWith(color: defaultColor))
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(postModel.postImage.isNotEmpty) Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(postModel.postImage),
                    fit: BoxFit.cover,
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_border, size: 16, color: Colors.red),
                          const SizedBox(width: 5),
                          Text('${SocialCubit.get(context).likes[index]}', style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.amber),
                          const SizedBox(width: 5),
                          Text('0 comments', style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(SocialCubit.get(context).userModel.image),
                      ),
                      const SizedBox(width: 15),
                      Text('write a comment ...', style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 16, color: Colors.red),
                    const SizedBox(width: 5),
                    Text('Like', style: Theme.of(context).textTheme.caption)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}