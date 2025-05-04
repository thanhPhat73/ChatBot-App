import 'package:chat/constants/constants.dart';
import 'package:chat/widgets/Text_widget.dart';
import 'package:flutter/material.dart';

import '../services/assets_manager.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0 ? AssetsManager.userImage : AssetsManager.chatLogoImage,
                  height: 30,
                  width: 30,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(child: TextWidget(label: msg))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
