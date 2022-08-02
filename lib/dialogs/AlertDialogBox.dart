import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:manek_tech_practicle/utils/Constant.dart';
import 'package:manek_tech_practicle/utils/Styles.dart';
import 'package:manek_tech_practicle/widgets/BottomWidget.dart';

class AlertDialogBox extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const AlertDialogBox(
      {Key? key, required this.errorMessage, required this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.defualtRadius),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        children: [
          Center(
            child: Container(
              width: Get.width / 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, top: 10, right: 15, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: Constant.height20, bottom: Constant.height20),
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: descriptionTextStyle
                      ),
                    ),
                    SizedBox(height: 30),
                    Bounce(
                        duration:
                            (Duration(milliseconds: Constant.boundAnimationDuration)),
                        onPressed: () {
                          onRetryPressed();
                        },
                        child: BottonWidget(title: 'Okay'))
                   
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}