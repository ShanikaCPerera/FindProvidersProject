import 'package:flutter/material.dart';

import '../app_colors.dart';

class CustomErrorScreen extends StatelessWidget {
  const CustomErrorScreen({Key? key, required this.errorMessage}) : super(key: key);
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            //TODO should navigate back or not allowed
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          icon:const Icon(
            Icons.arrow_back_ios,
            color: AppColor.darkIconColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_error.jpg'),
            const Text(
              "Oops!",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                fontSize: 15,
                color: AppColor.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}