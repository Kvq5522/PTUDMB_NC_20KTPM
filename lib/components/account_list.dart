import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

class AccountList extends StatefulWidget {
  final accountList;

  const AccountList({super.key, required this.accountList});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  bool toggle = false;
  int chosenIndex = 0;

  late UserInfoStore userInfoStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userInfoStore = Provider.of<UserInfoStore>(context);
    userInfoStore.setUserType(widget.accountList[chosenIndex]['userType']);
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

          print('set user type: ${account["userType"]}');

          userInfoStore.setUserType(account['userType']);
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
                    account['userType'],
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
