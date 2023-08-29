import 'package:flutter/material.dart';
import '../app_colors.dart';

class UtilityWidgets{

  static void showSuccessToast(BuildContext context, String content) {
    content = "Success: $content";
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration( seconds: 2),
        backgroundColor: AppColor.primaryThemeColor,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: scaffold.hideCurrentSnackBar,
          disabledTextColor: Colors.white,
          textColor: AppColor.highlightTextColor,
        ),
      ),
    );
  }

  static void showErrorToast(BuildContext context, String content) {
    content = "Error: $content";
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration( seconds: 4),
        backgroundColor: AppColor.errorBackgroundColor,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: scaffold.hideCurrentSnackBar,
          disabledTextColor: Colors.white,
          textColor: AppColor.highlightTextColor,
        ),
      ),
    );
  }

  static Widget errorScreen(BuildContext context, String errorText, String? title){
    return Scaffold(
        backgroundColor: AppColor.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.primaryThemeColor,
          title: Text(title ?? ""),
          centerTitle: true,
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
                  color: AppColor.errorTextColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0, right:20.0),
                child: Text(
                  errorText,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  static void showFloatingErrorToast(BuildContext context, String content){
    //content = "Error: $content Contact administrator.";
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: AppColor.errorBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular((20)))
            ),
            child: Center(child: Text(content, textAlign: TextAlign.center,))
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        duration: const Duration( seconds: 8),
        backgroundColor: Colors.transparent,
        // action: SnackBarAction(
        //   label: 'Dismiss',
        //   onPressed: scaffold.hideCurrentSnackBar,
        //   disabledTextColor: Colors.white,
        //   textColor: Colors.yellow,
        // ),
      ),
    );
  }

  static Widget emptyDataWidget(BuildContext context, String text){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_data.jpg'),
          Padding (
            padding: const EdgeInsets.only(left:20.0, right:20.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15
              ),
            ),
          ),
        ]
    );
  }

}