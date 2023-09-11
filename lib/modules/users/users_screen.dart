import 'package:flutter/material.dart';
import 'package:stover/models/user/user_model.dart';


class UsersScreen extends StatelessWidget {
  // const UsersScreen({Key? key}) : super(key: key);
  List<UserModel> users = [
    UserModel(
      id: 1,
      name: 'Mohamed Adel',
      phone: '+201013922284',
    ),
    UserModel(
      id: 2,
      name: 'MO Adel',
      phone: '+201113922284',
    ),
    UserModel(
      id: 3,
      name: 'Mohamed Haikel',
      phone: '+201213922284',
    ),
    UserModel(
      id: 4,
      name: 'Mohamed Ali',
      phone: '+201513922284',
    ),
    UserModel(
      id: 1,
      name: 'Mohamed Adel',
      phone: '+201013922284',
    ),
    UserModel(
      id: 2,
      name: 'MO Adel',
      phone: '+201113922284',
    ),
    UserModel(
      id: 3,
      name: 'Mohamed Haikel',
      phone: '+201213922284',
    ),
    UserModel(
      id: 4,
      name: 'Mohamed Ali',
      phone: '+201513922284',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => bulidUserItem(users[index]),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
        itemCount: users.length,
      ),
    );
  }

  Widget bulidUserItem(UserModel user) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              child: Text(
                '${user.id}',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name}',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${user.phone}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // 1. Build item
  // 2. Build list
  // 3. Add item to list
}
