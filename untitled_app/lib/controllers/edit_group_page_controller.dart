import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/groups_page_controller.dart';
import 'package:untitled_app/custom_widgets/warning_dialog.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/localization/generated/app_localizations_en.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../utilities/constants.dart' as c;
import '../models/users.dart';
import 'dart:async';
import '../models/search_model.dart';
import 'package:go_router/go_router.dart';
import '../models/group_handler.dart';
import '../models/current_user.dart';

class EditGroupPageController extends ChangeNotifier {
  String icon = "";
  final searchTextController = TextEditingController();
  final PageController pageController = PageController();
  final selectedPeopleScroll = ScrollController();
  List<AppUser> selectedPeople = [];
  List<AppUser> hits = [];
  List<AppUser> membersList = [];
  List<AppUser> addedMembers = [];
  bool isLoading = false;
  bool showEmojiKeyboard = false;
  Timer? _debounce;
  int? selectedToDelete;
  BuildContext context;
  bool canSwipe = false;

  Group group;

  EditGroupPageController({required this.context, required this.group}) {
    init();
  }

  init() async {
    for (var uid in group.members) {
      AppUser user = AppUser();
      Map<String, dynamic>? userData = await user.readUserData(uid);
      if (userData != null) {
        membersList.add(AppUser.fromJson(userData));
      }
    }
    notifyListeners();
  }

  void goForward() {
    pageController.nextPage(
        duration: const Duration(milliseconds: c.signUpAnimationDuration),
        curve: Curves.decelerate);
  }

  void exitPressed() {
    goBack();
  }

  void goBack() {
    hideKeyboard();
    if (pageController.page != 0.0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: c.signUpAnimationDuration),
          curve: Curves.decelerate);
    } else {
      context.pop();
    }
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
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
        hits.removeWhere(
            (element) => element.uid == locator<CurrentUser>().getUID());
        isLoading = false;
        notifyListeners();
      }
    });
  }

  bool isUserSelected(AppUser user) {
    for (AppUser slectedUser in selectedPeople) {
      if (user.uid == slectedUser.uid) {
        return true;
      }
    }
    for (AppUser slectedUser in membersList) {
      if (user.uid == slectedUser.uid) {
        return true;
      }
    }
    return false;
  }

  void addRemovePersonToList(AppUser user, bool add) {
    if (add) {
      selectedPeople.add(user);
      addedMembers.add(user);
      Timer(const Duration(milliseconds: 50), () {
        selectedPeopleScroll.animateTo(
          selectedPeopleScroll.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      });
    } else {
      if (addedMembers.contains(user)) {
        selectedPeople.removeWhere((element) => element.uid == user.uid);
      }
    }
    notifyListeners();
  }

  void setSelectedToDelete(int index) {
    if (index == selectedToDelete) {
      selectedPeople
          .removeWhere((element) => element.uid == selectedPeople[index].uid);
      selectedToDelete = null;
    } else {
      selectedToDelete = index;
    }
    notifyListeners();
  }

  void initializeSearch() {
    selectedPeople = [...addedMembers];
  }

  void updateGroupMembers() {
    pageController.previousPage(
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    membersList.addAll(selectedPeople);
    List<String> members = (membersList.map((e) => e.uid).toList());
    group.members = members;
    GroupHandler().updateGroupMembers(group, members);
  }

  void pickEmoji() async {
    context.pushNamed("pick_emoji", extra: _setIcon);
  }

  void _setIcon(String returnedString) {
    if (returnedString != "") icon = returnedString;
    notifyListeners();
  }

  void clearIcon() {
    icon = "";
    notifyListeners();
  }

  void _pop() {
    context.pop();
  }

  void _leaveGroup() async {
    context.pop();
    showLoadingDialog(context);

    List<String> bean = (membersList.map((e) => e.uid).toList());
    print(bean);
    print(membersList.length);
    membersList
        .removeWhere((user) => user.uid == locator<CurrentUser>().getUID());
    List<String> members = (membersList.map((e) => e.uid).toList());
    print(members);
    GroupHandler().updateGroupMembers(group, members).then(
      (v) {
        _pop();
        context.go("/groups", extra: true);
      },
    );
  }

  void leaveGroup() {
    showMyDialog(
        AppLocalizations.of(context)!.leaveGroupWarningTitle,
        AppLocalizations.of(context)!.leaveGroupWarningTitle,
        [
          AppLocalizations.of(context)!.cancel,
          AppLocalizations.of(context)!.exit
        ],
        [_pop, _leaveGroup],
        context);

    // TODO: needs to reload the groups page
  }
}
