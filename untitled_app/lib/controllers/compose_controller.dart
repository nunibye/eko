import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/models/current_user.dart';
import '../models/search_model.dart';
import '../utilities/constants.dart' as c;
import '../custom_widgets/error_snack_bar.dart';
import 'package:giphy_get/giphy_get.dart';
import '../utilities/locator.dart';
import '../models/post_handler.dart';
import '../secrets/secrets.dart' as secrets;
import 'bottom_nav_bar_controller.dart';
import '../custom_widgets/post_card.dart';
import "package:go_router/go_router.dart";
import 'package:untitled_app/models/feed_post_cache.dart';
import '../models/users.dart' show AppUser;
import '../controllers/bottom_nav_bar_controller.dart';
import '../models/group_handler.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;
import '../custom_widgets/pagination.dart';
import '../custom_widgets/group_card.dart';

class ComposeController extends ChangeNotifier {
  final BuildContext context;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final titleFocus = FocusNode();
  final bodyFocus = FocusNode();
  Group? groupEndPoint;
  // List<String> tags;
  String audience;
  int newLines = 0;
  int bodyChars = 0;
  int titleChars = 0;
  bool showCount0 = false;
  bool showCount1 = false;
  GiphyGif? gif;
  bool isAtSymbolTyped = false;
  bool isLoading = false;
  List<AppUser> hits = [];
  Timer? _debounce;

  ComposeController(
      {required this.context, required this.audience, this.groupEndPoint}) {
    titleFocus.addListener(onTitleFocusChanged);
    bodyFocus.addListener(onBodyFocusChanged);
    // _init();
  }
  // void _init() {
  //   // print(audience);
  //   // notifyListeners();
  // }

  void onTitleFocusChanged() {
    if (titleFocus.hasFocus) {
      showCount0 = true;
    } else {
      showCount0 = false;
    }
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    locator<NavBarController>().goBranch(0);
    return false;
  }

  void onBodyFocusChanged() {
    if (bodyFocus.hasFocus) {
      showCount1 = true;
    } else {
      showCount1 = false;
    }
    notifyListeners();
  }

  // changeDisplayCount(bool value, int index) {
  //   if (index == 0) {
  //     showCount0 = value;
  //   } else {
  //     showCount1 = value;
  //   }
  //   notifyListeners();
  // }

  updateCountsBody(String str) {
    bodyChars = str.length;
    newLines = '\n'.allMatches(str).length;
    notifyListeners();
  }

  updateCountsTitle(String str) {
    titleChars = str.length;
    notifyListeners();
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  removeGifPressed() {
    gif = null;
    notifyListeners();
  }

  clearPressed() {
    hideKeyboard();
    gif = null;
    newLines = 0;
    bodyChars = 0;
    titleChars = 0;
    showCount0 = false;
    showCount1 = false;
    titleController.text = "";
    bodyController.text = "";
    notifyListeners();
  }

  void _onAudienceGroupCardPressed(Group group) {
    // print("test");
    groupEndPoint = group;
    audience = group.name;
    context.pop();
    notifyListeners();
  }

  dynamic _getTimeFromGroup(dynamic group) {
    return (group as Group).lastActivity;
  }

  Future<PaginationGetterReturn> _getGroups(dynamic time) {
    return GroupHandler().getGroups(time);
  }

  Widget _groupCardSearchBuilder(dynamic group) {
    return GroupCard(
      group: group,
      onPressedSearched: _onAudienceGroupCardPressed,
    );
  }

  void audianceButtonPressed() {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final double width = MediaQuery.sizeOf(context).width;
        return SizedBox(
            child: PaginationPage(
                header: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          AppLocalizations.of(context)!.selectAudience,
                          style: const TextStyle(fontSize: 24),
                        )),
                    Divider(
                      color: Theme.of(context).colorScheme.outline,
                      height: c.dividerWidth,
                    ),
                    InkWell(
                      onTap: () {
                        groupEndPoint = null;
                        audience = AppLocalizations.of(context)!.public;
                        context.pop();
                        notifyListeners();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Icon(Icons.public, size: width * 0.18),
                            SizedBox(
                              width: width * 0.05,
                            ),
                            Text(
                              AppLocalizations.of(context)!.public,
                              style: const TextStyle(fontSize: 19),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outline,
                      height: c.dividerWidth,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding:
                            const EdgeInsets.only(left: 7, top: 12, bottom: 12),
                        child: Text(
                          AppLocalizations.of(context)!.myGroups,
                          style: const TextStyle(fontSize: 18),
                        ))
                  ],
                ),
                shrinkWrap: true,
                getter: _getGroups,
                card: _groupCardSearchBuilder,
                startAfterQuery: _getTimeFromGroup));
      },
    );
  }

  addGifPressed() async {
    locator<NavBarController>().disable();
    GiphyGif? newGif = await GiphyGet.getGif(
      context: context,
      apiKey: secrets.Secrets.GIPHY_API_KEY,
      lang: GiphyLanguage.english,
      //randomID: "abcd", // Optional - An ID/proxy for a specific user.
      tabColor: Colors.teal,
      debounceTimeInMilliseconds: 350,
    );
    //only update gif a gif was selected
    if (newGif != null) {
      gif = newGif;
    }
    notifyListeners();
    locator<NavBarController>().enable();
  }

  _goToPage({Group? group}) {
    if (group == null) {
      context.go("/feed", extra: true);
    } else {
      context.go("/groups/sub_group/${group.id}", extra: group);
    }
  }

//TODO add more content like a preview of a post.
  postPressed(BuildContext context) {
    final List<String> tags = [
      (groupEndPoint != null) ? groupEndPoint!.id : "public"
    ];

    bodyController.text = bodyController.text.trim();
    titleController.text = titleController.text.trim();
    updateCountsBody(bodyController.text);
    updateCountsTitle(titleController.text);
    if (titleChars > c.maxTitleChars) {
      showSnackBar(
          text: AppLocalizations.of(context)!.tooManyChar, context: context);
    } else if (newLines > c.maxPostLines) {
      showSnackBar(
          text: AppLocalizations.of(context)!.tooManyLine, context: context);
    } else if (bodyChars > c.maxPostChars) {
      showSnackBar(
          text: AppLocalizations.of(context)!.tooManyChar, context: context);
    } else if (titleController.text == "" &&
        bodyController.text == "" &&
        gif == null) {
      titleFocus.requestFocus();
      showSnackBar(
          text: AppLocalizations.of(context)!.emptyFieldError,
          context: context);
    } else {
      Map<String, dynamic> post = {};
      post["tags"] = tags;
      if (titleController.text != '') {
        post["title"] = titleController.text;
      }
      if (bodyController.text != '') {
        post["body"] = bodyController.text;
      }
      if (gif != null) {
        post["gifUrl"] = gif!.images!.fixedWidth.url;
        post["gifSource"] = gif!.url;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(AppLocalizations.of(context)!.confirmation),
            content: SingleChildScrollView(
              child: PostCard(
                  post: Post(
                      tags: tags,
                      gifSource: post["gifSource"],
                      gifURL: post["gifUrl"],
                      postId: "postId",
                      time: "", //DateTime.now().toUtc().toIso8601String(),
                      title: Post.parseText(post["title"]),
                      author: AppUser.fromCurrent(locator<CurrentUser>()),
                      body: Post.parseText(post["body"]),
                      likes: 0),
                  isPreview: true),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  context.pop();
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.post),
                onPressed: () async {
                  context.pop();

                  final postID =
                      await locator<PostsHandling>().createPost(post);
                  if (tags.contains("public")) {
                    locator<FeedPostCache>().addPost(
                      2,
                      Post(
                        tags: tags,
                        gifSource: post["gifSource"],
                        gifURL: post["gifUrl"],
                        postId: postID,
                        time: DateTime.now().toUtc().toIso8601String(),
                        title: Post.parseText(post["title"]),
                        author: AppUser.fromCurrent(locator<CurrentUser>()),
                        body: Post.parseText(post["body"]),
                        likes: 0,
                      ),
                    );

                    _goToPage();
                  } else {
                    _goToPage(group: groupEndPoint);
                    //refine cases later for more complicated tag system
                  }
                  titleController.text = "";
                  bodyController.text = "";
                  gif = null;
                  notifyListeners();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void checkAtSymbol(String text) {
    int start = text.lastIndexOf('@');
    if (start != -1 && start < text.length - 1) {
      int end = text.indexOf(' ', start);
      if (end == -1) {
        // No space found after '@'
        isAtSymbolTyped = true;
        //isUsernameFinished = false;
        onSearchTextChanged(text.substring(start + 1));
        notifyListeners();
      } else if (text.substring(end).contains('@')) {
        // Another '@' found after space
        isAtSymbolTyped = true;
        //isUsernameFinished = false;
        onSearchTextChanged(text.substring(start + 1, end));
        notifyListeners();
      } else {
        // Space found after '@' and no other '@' found
        isAtSymbolTyped = false;
        //isUsernameFinished = true;
      }
    } else {
      isAtSymbolTyped = false;
      //isUsernameFinished = false;
    }
  }

  void updateTextField(
      String username, TextEditingController controller, FocusNode focus) {
    if (focus.hasFocus) {
      String currentText = controller.text;
      int atSymbolIndex = currentText.lastIndexOf('@');
      if (atSymbolIndex != -1) {
        String newText =
            '${currentText.substring(0, atSymbolIndex)}@$username ';
        controller.text = newText;
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: newText.length));
      }
      isAtSymbolTyped = false;
      notifyListeners();
    }
  }

  void onSearchTextChanged(String s) async {
    if (s == '') {
      hits = [];

      isLoading = false;
      notifyListeners();
    } else {
      isLoading = true;
      notifyListeners();
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce =
        Timer(const Duration(milliseconds: c.searchPageDebounce), () async {
      if (s != '') {
        hits = await SearchModel().hitsQuery(s);
        isLoading = false;
        notifyListeners();
      }
    });
  }
}
