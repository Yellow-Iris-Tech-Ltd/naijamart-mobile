import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/constants/endpoints_uri.dart';

class MeDashboardScreen extends StatefulWidget {
  static const routeName = '/me';
  const MeDashboardScreen({super.key});
  @override
  State<MeDashboardScreen> createState() => _MeDashboardScreenState();
}

class _MeDashboardScreenState extends State<MeDashboardScreen> {
  late final WebViewController _controller;
  var loadingPercentage = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('naijamart_token') ?? '';
    
    final cookieManager = WebViewCookieManager();
    
    if (token.isNotEmpty) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'naijamart_token',
          value: token,
          domain: 'www.naijamart.com',
          path: '/',
        ),
      );
    }
    
    _controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => setState(() => loadingPercentage = 0),
        onProgress: (p) => setState(() => loadingPercentage = p),
        onPageFinished: (url) => setState(() => loadingPercentage = 100),
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message.message,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ));
        },
      )
      ..loadRequest(Uri.parse(NaijaMartEndpoints.domainUrl));
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    if (!_ready) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('NaijaMart'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await _controller.canGoBack()) {
                  await _controller.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 200),
                    content: Text("Can't go back",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ));
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await _controller.canGoForward()) {
                  await _controller.goForward();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 200),
                    content: Text('No forward history',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ));
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () => _controller.reload(),
            ),
            _Menu(controller: _controller),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (loadingPercentage < 100)
              LinearProgressIndicator(value: loadingPercentage / 100.0),
          ],
        ),
      ),
    );
  }
}

enum _MenuOptions { home, deleteData }

class _Menu extends StatelessWidget {
  const _Menu({required this.controller});
  final WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.home:
            await controller.loadRequest(Uri.parse(NaijaMartEndpoints.domainUrl));
            break;
          case _MenuOptions.deleteData:
            await controller.loadRequest(Uri.parse(
                'https://docs.google.com/forms/d/e/1FAIpQLSegI23JIYM-huHBrZ_DAKVigu88morvt6kztmYf1CPbe5pTMA/viewform'));
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: _MenuOptions.home, child: Text('Home')),
        PopupMenuItem(value: _MenuOptions.deleteData, child: Text('Delete Data')),
      ],
    );
  }
}