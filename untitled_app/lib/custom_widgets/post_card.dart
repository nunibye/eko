import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'controllers/post_card_controller.dart';
import '../utilities/constants.dart' as c;
import '../models/post_handler.dart' show Post;
import 'package:provider/provider.dart';
import 'profile_picture_loading.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PostCardController(post: post, context: context),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Divider(
                  color: Colors.grey[30],
                  height: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: c.postPaddingHoriz,
                  vertical: c.postPaddingVert,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the profile picture as a CircleAvatar
                    IconButton(
                      onPressed: () => Provider.of<PostCardController>(context,
                              listen: false)
                          .iconPressed(),
                      padding: EdgeInsets.all(5),
                      icon: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.115,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: post.profilePic,
                            placeholder: (context, url) =>
                                const LoadingProfileImage(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${post.firstName} ${post.lastName}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                "@${post.username}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            post.body,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: c.postPaddingHoriz,
                  vertical: c.postPaddingVert,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => {},
                      icon: Row(
                        children: [
                          Icon(
                            Icons.comment,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: c.postIconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '0',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => {},
                      icon: Row(
                        children: [
                          Icon(
                            Icons.repeat,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: c.postIconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '0',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Provider.of<PostCardController>(context,
                              listen: false)
                          .likePressed(),
                      icon: Row(
                        children: [
                          Icon(
                            (Provider.of<PostCardController>(context,
                                        listen: true)
                                    .liked)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: c.postIconSize,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${Provider.of<PostCardController>(context, listen: true).likes}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
