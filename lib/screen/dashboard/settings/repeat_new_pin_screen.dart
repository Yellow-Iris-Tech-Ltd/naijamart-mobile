
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wow/screen/dashboard/bottom_navigation.dart';

import '../../../common/mixins/automatic_logout_mixin.dart';
import '../../../common/validators/is_valid.dart';
import '../../../common/widgets/alert_utility.dart';
import '../../../common/widgets/button_gradient.dart';
import '../../../data/cubit/notification/notification_cubit.dart';
import '../../../data/cubit/security/security_cubit.dart';
import '../../../data/cubit/security/update_pin_state.dart';
import '../../../util/constants/naijamart_app_colors.dart';


class RepeatNewPinScreen extends StatefulWidget {
  static const routeName = '/repeat-new-pin';
  const RepeatNewPinScreen({super.key});

  @override
  State<RepeatNewPinScreen> createState() => _RepeatNewPinScreenState();
}

class _RepeatNewPinScreenState extends State<RepeatNewPinScreen> with AutomaticLogoutMixin{

  FocusNode pinNumberFocus = FocusNode();
  final TextEditingController _pinController = TextEditingController();
  late SecurityCubit _securityCubit;
  late NotificationCubit _notificationCubit;

  @override
  void initState(){
    super.initState();
    _securityCubit = BlocProvider.of<SecurityCubit>(context);
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
  }

  onNumberTapped(number, BuildContext ctx) async {
    onUserInteraction();
    setState(() {
      if(_pinController.text.length < 4){
        _pinController.text += number;
      }
    });


  }

  Widget inputField(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      color: Colors.grey[100],
      alignment: Alignment.bottomCenter,
      child:
      TextFormField(
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        controller: _pinController,
        decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor:Colors.grey[100]//NaijaMartAppColors.OtpPinKey
        ),
      ),
    );
  }

  Widget keyField(numKey){
    return GestureDetector(
      onTap: () => onNumberTapped(numKey, context),
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: NaijaMartAppColors.OtpPinKey,
            borderRadius: BorderRadius.circular(40)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(numKey,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  onCancelText(){
    onUserInteraction();
    setState(() {
      if(_pinController.text.isNotEmpty){
        var newValue = _pinController.text.substring(0, _pinController.text.length - 1);
        _pinController.text = newValue;
      }
    });

  }

  Widget backSpace(){
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () => onCancelText(),
        child: Container(
            child: const Icon(Icons.keyboard_backspace)
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final w = MediaQuery.of(context).size.width, h = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: SizedBox(
          // height: h,
          width: w,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                SizedBox(
                  width: w,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                          left: 20,
                          top: 10,
                          child: BlackSquareButton(
                            icon: Icons.chevron_left,
                            borderColor: Colors.black,
                            onPressed: () {
                              onUserInteraction();
                              if(Navigator.of(context).canPop()){
                                // Navigator.of(context).pushNamed(DashboardNavigationScreen.routeName);
                                Navigator.pop(context);
                              }
                            },
                          )

                      ),

                      Positioned(
                        top: 15,
                        child: Text(
                          "Confirm Pin",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),

                SizedBox(
                  width: w,
                  // height: h * .,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Confirm New Pin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                          ],
                        ),
                        const SizedBox(height: 7),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Enter the 4-digits secure pin\nyou'd like to change to ", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF8C8F93)),),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(_pinController.text, style:  TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: NaijaMartAppColors.YelloGrad1)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            children: [
                              keyField("1"),
                              keyField("2"),
                              keyField("3"),
                              keyField("4"),
                              keyField("5"),
                              keyField("6"),
                              keyField("7"),
                              keyField("8"),
                              keyField("9"),
                              Container(),
                              keyField("0"),
                              Container(
                                child: backSpace(),
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40,),

                BlocBuilder<SecurityCubit, UpdateChangePinState>(
                  builder: (context, state) {
                    if(state is UpdateChangePinProgress){
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * .10,
                          child: const Center(child: CircularProgressIndicator(color: NaijaMartAppColors.YelloGrad1,))
                      );
                    } else if(state is UpdateChangePinSuccess){
                      return buildChangePinButton(context);
                    } else if(state is UpdateChangePinFailure){
                      return buildChangePinButton(context);
                    } else {
                      return buildChangePinButton(context);
                    }
                  },
                )

                // return buildChangePinButton(context);
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildChangePinButton(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child:
                    GradientCircularButton(
                        icon: Icons.chevron_right,
                        onPressed: () async {
                          onUserInteraction();
                          if(_pinController.text.isEmptyOrNull && !checkPinValidity(_pinController.text)){
                            showToastMessage(message: "Empty or Invalid Pin");
                            return;
                          }

                          bool status = await _securityCubit.mutateTxnPin(_pinController.text);

                          if(status){
                            _notificationCubit.sendNotification(
                                "Pin changed",
                                "Pin changed/updated successful"
                            );

                            showToastMessage(message: "Pin changed/updated successful");
                            Navigator.of(context).pushNamed(DashboardNavigationScreen.routeName);


                          } else {
                            showToastMessage(message: "Try again");
                            Navigator.of(context).pushNamed(DashboardNavigationScreen.routeName);
                          }
                        }
                    ),
                  ),
                ],
              );
  }
}
