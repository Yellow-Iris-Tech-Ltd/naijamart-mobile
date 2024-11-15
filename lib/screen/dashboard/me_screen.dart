import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:naijamart/util/constants/naijamart_app_colors.dart';

import '../../common/mixins/automatic_logout_mixin.dart';
import '../../common/validators/is_valid.dart';
import '../../common/widgets/alert_utility.dart';
import '../../common/widgets/button_gradient.dart';
import '../../util/cache/encrypted_storage.dart';
import '../../util/cache/local.dart';
import '../../util/constants/endpoints_uri.dart';
import '../../util/constants/images_uri.dart';
import 'bottom_navigation.dart';
import 'home/all_notifications_screen.dart';

class MeDashboardScreen extends StatefulWidget {
  static const routeName = '/me';
  const MeDashboardScreen({super.key});

  @override
  State<MeDashboardScreen> createState() => _MeDashboardScreenState();
}

class _MeDashboardScreenState extends State<MeDashboardScreen> with AutomaticLogoutMixin {


  late final WebViewController _controller; // = WebViewController();
  final LocalCache _localCache = LocalCache();


  late final EncryptedStorage storage;

  String? _userFirstName;
  String? _userSecondName;
  String? _userName;
  String? _accountNumber;
  String? _bankName;
  String? _photoUrl;
  String? _credentialAuthEmail;
  String? _credentialAuthPassword;
  String? _token;
  int? _txnPin;
  double? _currentBalance = 0.0;


  bool showWalletBalance = false;
  bool enableBiometric = false;
  bool enable2Fauth = false;
  bool hasPin = false;
  bool _kycStatus = false;


  @override
  void initState(){
    super.initState();

    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    storage = EncryptedStorage();


    // _initUserDetails();
  }


Future<void> _initUserDetails() async {
}



  Future<void> _loadUrl(Uri uri) async {
    await _controller.loadRequest(uri);

}


  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final Uri liveUrl = Uri.parse("${NaijaMartEndpoints.liveUrl}");

    try{
      future: _loadUrl(liveUrl);
      WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewUI(controller: _controller),
        ),
      );
      })
    } catch (e){
      showToastMessage(message: "Failed to launch customer support link");
      debugPrint(e.toString());
    }
 

    final w = MediaQuery.of(context).size.width, h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop)  {
            if(didPop){
              // showToastMessage(message: "Back key pressed");
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF1F1F1),
            body:
            NotificationListener<ScrollNotification>(
              onNotification: (notification){
                if(notification is ScrollUpdateNotification){
                  onUserInteraction();
                }
                return true;
              },
              child: RefreshIndicator(
                color: NaijaMartAppColors.YellowGrad2,
                backgroundColor: Colors.white,
                onRefresh: _initUserDetails,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: w,
                    // height: h * 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(

                        children: <Widget>[
                          const SizedBox(height: 5),
                          SizedBox(
                            width: w,
                            height: h * .1,
                            child:
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned(
                                    left: 0,
                                    top: 10,
                                    child: BlackSquareButton(
                                      icon: Icons.chevron_left,
                                      borderColor: Colors.black,
                                      onPressed: () {
                                        onUserInteraction();
                                        // Navigator.pop(context);
                                        Navigator.of(context).pushNamed(
                                            DashboardNavigationScreen.routeName,
                                          arguments: {'initialSelectedIndex': 3},
                                        );
                                      },
                                    )
                                ),
                                const Positioned(
                                  top: 15,
                                  child: Text("Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.notifications_none), onPressed: () {
                                    onUserInteraction();
                                    Navigator.of(context).pushNamed(
                                      AllNotificationsScreen.routeName,);
                                  },
                                  ),

                                ),

                              ],
                            ),

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}

class WebViewUI extends StatefulWidget {
  final WebViewController controller;
  const WebViewUI({super.key, required this.controller});

  @override
  State<WebViewUI> createState() => _WebViewUIState();
}

class _WebViewUIState extends State<WebViewUI> {
  var loadingPercentage = 0;
  late WebViewController controller;
  @override
  void initState(){
    super.initState();
    controller = widget.controller;
    widget.controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url){
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress){
          setState(() {
            loadingPercentage = progress;
          });
        },

        onPageFinished: (url){
          setState(() {
            loadingPercentage = 100;
          });
        }
      )
    );
    

    widget.controller.addJavaScriptChannel("Snackbar", onMessageReceived: (message){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
    });
  }


  @override
  Widget build(BuildContext context) {

    final w = MediaQuery.of(context).size.width, h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("NaijaMart"),
          actions: [
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    if (await controller.canGoBack()) {
                      await controller.goBack();
                    } else {
                      messenger.showSnackBar(
                        const SnackBar(
                            duration: Duration(milliseconds: 200),
                            content: Text(
                              'Can\'t go back',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      );
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    if (await controller.canGoForward()) {
                      await controller.goForward();
                    } else {
                      messenger.showSnackBar(
                        const SnackBar(
                            duration: Duration(milliseconds: 200),
                            content: Text(
                              'No forward history item',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      );
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: () {
                    controller.reload();
                  },
                ),
              ],
            )
          ]
        ),
        body: Stack(
              children: [
                WebViewWidget(controller: widget.controller),
                loadingPercentage < 100 ?
                  LinearProgressIndicator(
                    value: loadingPercentage / 100.0,
                  ) : Container()
              ],
        ),
      ),
    );
  }
}




