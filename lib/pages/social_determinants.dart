import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../blocs/user_bloc.dart';
import '../services/exception_handler.dart';
import '../utility/ui_messages.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';

class SocialDeterminants extends StatefulWidget {
  const SocialDeterminants({super.key});

  @override
  State<SocialDeterminants> createState() => _SocialDeterminantsState();
}

class _SocialDeterminantsState extends State<SocialDeterminants> {
  YoutubePlayerController? _youTubeController;

  @override
  void initState() {
    _youTubeController = YoutubePlayerController(
      initialVideoId: 'lyc2FxZXJ4s',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.primaryThemeColor,
              title: const Text(
                'Social Determinants of Health Resources',
                style: TextStyle(
                  fontSize: 15,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                  }
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      //player,
                      YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _youTubeController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: AppColor.progressIndicatorColor,
                          progressColors: const ProgressBarColors(
                            playedColor: AppColor.progressIndicatorColor,
                            handleColor: AppColor.progressHandleColor
                          ),
                        ),
                      builder: (context, player){
                          return player;
                        }
                      ),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Instructional Video: Focused History Script",
                          style: TextStyle(
                              color: AppColor.titleTextColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        color: AppColor.sectionBackgroundColor,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'SDOH Surveys',
                            style: TextStyle(
                              color: AppColor.titleTextColor,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: const Text(
                          'SDOH Script',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                        leading: const Icon(Icons.file_copy_outlined),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: AppColor.primaryThemeColor,
                          ),
                          onPressed: () {
                            downloadSurveyTemplate("SDOH Script by Domain_App Development_Fillable PDF.pdf");
                          },
                        ),
                        onTap: null,
                      ),
                      Container(
                        color: AppColor.sectionBackgroundColor,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'SDOH Education',
                            style: TextStyle(
                              color: AppColor.titleTextColor,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: const Text(
                          'Secondary School Athletic Trainers Clinical Management Decisions of Low Socioeconomic Status Patients',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                        leading: const Icon(Icons.file_copy_outlined),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: AppColor.primaryThemeColor,
                          ),
                          onPressed: () {
                            downloadSurveyTemplate("Secondary School Athletic Trainers Clinical Management Decisions of Low Socioeconomic Status Patients.pdf");
                          },
                        ),
                        onTap: null,
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: const Text(
                          'Secondary School Socioeconomic Status and Athletic Training Practice Characteristics',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                        leading: const Icon(Icons.file_copy_outlined),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: AppColor.primaryThemeColor,
                          ),
                          onPressed: () {
                            downloadSurveyTemplate("Secondary School Socioeconomic Status and Athletic Training Practice Characteristics.pdf");
                          },
                        ),
                        onTap: null,
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: const Text(
                          'Social Determinants of Health- Considerations for Athletic Health Care',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                        leading: const Icon(Icons.file_copy_outlined),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: AppColor.primaryThemeColor,
                          ),
                          onPressed: () {
                            downloadSurveyTemplate("Social Determinants of Health- Considerations for Athletic Health Care.pdf");
                          },
                        ),
                        onTap: null,
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: const Text(
                          'SSAT SES Qual',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                        leading: const Icon(Icons.file_copy_outlined),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: AppColor.primaryThemeColor,
                          ),
                          onPressed: () {
                            downloadSurveyTemplate("SSAT SES Qual.pdf");
                          },
                        ),
                        onTap: null,
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: const Text(
                          'Validation of a Script to Facilitate Social Determinant of Health Conversations with Adolescent Patients',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                        leading: const Icon(Icons.file_copy_outlined),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: AppColor.primaryThemeColor,
                          ),
                          onPressed: () {
                            downloadSurveyTemplate("Validation of a Script to Facilitate Social Determinant of Health Conversations with Adolescent Patients.pdf");
                          },
                        ),
                        onTap: null,
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void downloadSurveyTemplate(String fileName) async{

    try {
      if (await userBloc.downloadSocialDetSurveyTemplate(fileName)) {
        if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_DOWNLOAD_FILE);
      }
    }catch (e, stacktrace){
      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }

      if (e is UnAuthorizedException){
        Navigator.popUntil(context, ModalRoute.withName('/'));
        UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else if (e is SessionTimeOutException){
        if (context.mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
        if (context.mounted) UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else {
        UtilityWidgets.showErrorToast(context, UiMessage.ERROR_DOWNLOAD_FILE);
      }
    }
  }

}
