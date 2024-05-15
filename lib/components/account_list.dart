import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountList extends StatefulWidget {
  final List accountList;

  const AccountList({super.key, required this.accountList});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  bool toggle = false;
  int chosenIndex = 0;

  late UserInfoStore _userInfoStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    if (_userInfoStore.userType.isNotEmpty) {
      final index = widget.accountList.indexWhere(
          (element) => element['userType'] == _userInfoStore.userType);

      if (index != -1) {
        setState(() {
          chosenIndex = index;
        });
      }

      if (widget.accountList[index]?["hasProfile"] == true) {
        _userInfoStore
            .setRoleId(BigInt.from(widget.accountList[index]["roleId"]));
        _userInfoStore.setHasProfile(true);
      }
    } else {
      _userInfoStore.setUserType(widget.accountList.isNotEmpty
          ? widget.accountList?[chosenIndex]?['userType']
          : "Student");

      if (widget.accountList[0]?["hasProfile"] == true) {
        _userInfoStore.setRoleId(BigInt.from(widget.accountList[0]["roleId"]));
        _userInfoStore.setHasProfile(true);
      }
    }

    _userInfoStore.setUsername(widget.accountList[chosenIndex]['username']);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _accountTile(widget.accountList[chosenIndex], chosenIndex),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: toggle ? _buildAccountList() : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildAccountList() {
    return ListView.builder(
      itemCount: widget.accountList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return index == chosenIndex
            ? const SizedBox()
            : _accountTile(widget.accountList[index], index);
      },
    );
  }

  Widget _accountTile(account, index) {
    return GestureDetector(
      onTap: () {
        if (index != chosenIndex) {
          setState(() {
            chosenIndex = index;
            toggle = !toggle;
          });

          print(account);
          _userInfoStore.setUserType(account['userType']);
          _userInfoStore.setUsername(account['username']);

          if (account["hasProfile"]) {
            _userInfoStore.setHasProfile(account['hasProfile']);
            _userInfoStore.setRoleId(BigInt.from(account['roleId']));
          } else {
            _userInfoStore.setHasProfile(false);
            _userInfoStore.setRoleId(BigInt.zero);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF008ABD)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(account['avatar']),
              radius: 30,
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display username
                  Text(
                    account['username'],
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 5),

                  // Display role
                  Text(
                    "${account['userType']}".tr(),
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Toggle arrow to show or hide account list
            index == chosenIndex
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        toggle = !toggle;
                      });
                    },
                    child: Transform.rotate(
                      angle: toggle ? 3.14 : 0,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
