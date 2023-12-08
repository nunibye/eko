import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/custom_widgets/profile_page_header.dart';
import 'package:untitled_app/models/users.dart' show AppUser;
import '../controllers/other_profile_controller.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/pagination.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/post_card.dart';

class OtherProfile extends StatelessWidget {
  final AppUser? user;
  const OtherProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OtherProfileController(context: context, user: user),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: () => context.pop("popped")),
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              Provider.of<OtherProfileController>(context, listen: true)
                  .loadedUser!
                  .username,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons
                    .more_horiz_outlined), //this could open a floating menu where you could block, or do something to adjust settings with this profile
              )
            ],
          ),
          body: PaginationPage(
              getter:
                  Provider.of<OtherProfileController>(context, listen: false)
                      .getPosts,
              card: profilePostCardBuilder,
              startAfterQuery:
                  Provider.of<OtherProfileController>(context, listen: false)
                      .getTimeFromPost,
              header: const _Header(),
              extraRefresh:
                  Provider.of<OtherProfileController>(context, listen: false)
                      .onPageRefresh),
          // FeedBuilder(
          //   user: AppUser(
          //       username:
          //           Provider.of<OtherProfileController>(context, listen: false)
          //               .loadedUser!.username,
          //       name:
          //           Provider.of<OtherProfileController>(context, listen: false)
          //               .loadedUser!.name,
          //       profilePicture:
          //           Provider.of<OtherProfileController>(context, listen: false)
          //               .loadedUser!.profilePicture,
          //       uid:
          //           Provider.of<OtherProfileController>(context, listen: false)
          //               .loadedUser!.uid),
          //   //query. Ok to be here in MVVM becasue it doesn't interact with database. Just a template for a request
          //   firestoreQuery: FirebaseFirestore.instance
          //       .collection('posts')
          //       .where("author",
          //           isEqualTo: Provider.of<OtherProfileController>(context,
          //                   listen: false)
          //               .loadedUser!.uid)
          //       .orderBy('time', descending: true),
          //   //This widget will be first in the list. use Column for this not ListView
          //   header: const _Header(),
          //   //Optional funtion to call on refresh.
          //   refreshFunction:
          //       Provider.of<OtherProfileController>(context, listen: false)
          //           .onPageRefresh,
          // )
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<OtherProfileController>(
          builder: (context, otherProfileController, _) => ProfileHeader(
            username: otherProfileController.loadedUser!.username,
            profilePic: otherProfileController.loadedUser!.profilePicture,
            likes: otherProfileController.loadedUser!.likes,
            following: otherProfileController.loadedUser!.following,
            followers: otherProfileController.loadedUser!.followers,
            profileBio: otherProfileController.loadedUser!.bio,
            name: otherProfileController.loadedUser!.name,
          ),
        ),
        //TODO style
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.1,
                child: TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  onPressed: () => Provider.of<OtherProfileController>(context,
                          listen: false)
                      .onFollowPressed(),
                  child: Text(
                    Provider.of<OtherProfileController>(context, listen: true)
                            .isFollowing
                        ? AppLocalizations.of(context)!.following
                        : AppLocalizations.of(context)!.follow,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
