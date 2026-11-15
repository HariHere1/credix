import 'package:flutter/material.dart';

import '../admin_theme.dart';

Future<String?> confirmWithReason(BuildContext context, {required String title, required String target, required String oldValue, required String newValue}) async {
  final reason = TextEditingController();
  String? error;
  final result = await showDialog<String>(context:context, builder:(dialogContext)=>StatefulBuilder(builder:(context,setState)=>AlertDialog(title:Text(title),content:SizedBox(width:440,child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(target,style:const TextStyle(fontWeight:FontWeight.w700)),const SizedBox(height:10),Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:AdminColors.canvas,borderRadius:BorderRadius.circular(10)),child:Text('$oldValue  →  $newValue',style:const TextStyle(fontSize:12))),const SizedBox(height:16),TextField(controller:reason,minLines:2,maxLines:4,decoration:InputDecoration(labelText:'Reason (required)',errorText:error,border:const OutlineInputBorder()))])),actions:[TextButton(onPressed:()=>Navigator.pop(dialogContext),child:const Text('Cancel')),FilledButton(onPressed:(){if(reason.text.trim().isEmpty){setState(()=>error='Please provide a reason.');return;} Navigator.pop(dialogContext,reason.text.trim());},child:const Text('Confirm'))])));
  reason.dispose();
  return result;
}
