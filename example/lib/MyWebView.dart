import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({Key? key}) : super(key: key);

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  double lineProgress = 0.0;
  BuildContext? mContext;
  String payStatus = "6001";

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onProgressChanged.listen((progress) {
      debugPrint("$progress");
      setState(() {
        lineProgress = progress;
      });
    });

    /// 监听链接变化
    flutterWebviewPlugin.onUrlChanged.listen((event) {
      print(event);
      if (event.contains("PaySuccess")) {
        payStatus = "9000";
      }
    });
    flutterWebviewPlugin.onBack.listen((event) {});
    flutterWebviewPlugin.evalJavascript("console.log('Hello, world!');");
    flutterWebviewPlugin.onStateChanged.listen((state) {
      // _getLinkData();
      // if (state.type == WebViewState.finishLoad) {
      //
      // }
    });
    // _getLinkData();
  }

  // void _getLinkData() async {
  //   String javascript = '''
  //     (function() {
  //       var xhr = new XMLHttpRequest();
  //       xhr.addEventListener("load", function() {
  //         // if (xhr.readyState === xhr.DONE && xhr.status === 200) {
  //         //
  //         // }
  //          var data = {url: xhr.responseURL, response: xhr.responseText};
  //           window.flutter_injector.postMessage(JSON.stringify(data));
  //       });
  //       xhr.open('GET', window.location.href, true);
  //       xhr.send();
  //     })();
  //   ''';
  //   String? response = await flutterWebviewPlugin.evalJavascript(javascript).then((value){
  //     print(value);
  //   });
  //   log.i(response);
  // }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return WillPopScope(
      child: WebviewScaffold(
        headers: {"referer": "https://sinoexpress.ttechworld.com/"},
        appBar: appBar(),
        url: "https://api.yedpay.com/online-payment/details/22Ia7Se2zaJLnXZB1fVq7qWZnLv52Rfn46Zhkz461Jw/zh",
        withJavascript: true,
        withLocalStorage: true,
        // hidden: true,
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        "测试",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        child: _progressBar(lineProgress, context),
        preferredSize: const Size.fromHeight(3.0),
      ),
    );
  }

  @override
  void dispose() {
    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white70.withOpacity(0),
      minHeight: 1.5,
      value: progress == 1.0 ? 0 : progress,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }
}
