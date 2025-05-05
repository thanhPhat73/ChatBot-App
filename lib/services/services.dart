import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/Text_widget.dart';
import '../widgets/drop_down_widget.dart';


class Services{
 static Future<void> showModelSheet({required BuildContext context}) async{
   await showModalBottomSheet(
       backgroundColor: scaffoldBackgroundColor,
       context: context,
       builder: (context) {
         return Padding(
           padding: const EdgeInsets.all(15.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Flexible(child: TextWidget(label: "chosen model")),
               Flexible(flex: 2,child: ModelsDrowDownWidget())
             ],
           ),
         );
       });
 }
}