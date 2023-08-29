import 'package:flutter/material.dart';

class AthleteProfileBloc with ChangeNotifier{

  //final picker = ImagePicker

  void pickImage(context)
  {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: (){},
                    leading: const Icon(Icons.camera),
                    title: const Text("Camera"),
                  ),
                  ListTile(
                    onTap: (){},
                    leading: const Icon(Icons.image),
                    title: const Text("Gallery"),
                  ),
                ],
            ),
            ),
          );
        }
    );
  }

}