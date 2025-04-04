import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove(); // Removes splash screen after 2 seconds
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hninsi Response',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WebViewApp(url: 'https://hninsiresponse.info/'),
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key, required this.url});
  final String url;
  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url));
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false; // App ကိုပိတ်မပစ်ဘဲ WebView မှာ back သွားစေမယ်။
    }
    return true; // WebView မှာ back သွားလို့မရတဲ့အခါ app ကိုပိတ်မယ်။
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // appBar: AppBar(title: const Text('Flutter WebView')),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
