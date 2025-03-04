import 'package:flutter/material.dart';
import 'package:movie_app/features/authentication/AuthRepo/AuthRepoImp.dart';
import 'package:movie_app/ui/components/AuthWidget.dart';
import 'package:movie_app/ui/screens/UserScreen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: AuthRepoImp().authStateChanges, builder: (context,snapshot){
      if(snapshot.hasData){
        return const UserScreen();
      }else{
        return  AuthWidget();
      }
    });
  }
}
