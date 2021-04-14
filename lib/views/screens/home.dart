import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_ui/views/widgets/post_item.dart';
import 'package:social_app_ui/util/data.dart';
import 'package:social_app_ui/util/router.dart';

import 'auth/login.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  void getUSD() async{
    String USD="";
    // SharedPreferences.setMockInitialValues({});


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Image.asset("assets/images/logo.png"),
        backgroundColor: Colors.orange,
        title: Text("placeQue Timeline"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: () async{
              prefs = await SharedPreferences.getInstance();
              print("tapped");
              prefs.remove('userToken').then((value) =>  Navigate.pushPageReplacement(context, Login()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return PostItem(
            img: post['img'],
            name: post['name'],
            dp: post['dp'],
            time: post['time'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}
