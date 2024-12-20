import 'package:chord_indonesia/app_bar.dart';
import 'package:chord_indonesia/constant_variable.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Apps extends StatefulWidget {
  const Apps({super.key, this.url, this.title});

  final String? url;
  final String? title;

  @override
  State<Apps> createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  double progressPercentage = 100;

  bool isBackButtonVisible = false;

  setLoadingProgress(int progress) {
    setState(() {
      progressPercentage = progress / 100;
      // print(progressPercentage);
    });
  }

  @override
  void initState() {
    super.initState();
    print("Initstate hit ${widget.url}");
    WidgetsBinding.instance.addPostFrameCallback((val) async {
      await globalWebViewController.setNavigationDelegate(
        NavigationDelegate(
          onProgress: setLoadingProgress,
          onPageStarted: (String url) {
            print("onPageStarted : $url");
          },
          onPageFinished: (String url) {
            // globalWebViewController.canGoBack().then((value) {
            //   setState(() {
            //     isBackButtonVisible = value;
            //   });
            // });
          },
          // onHttpError: (HttpResponseError error) {
          //   // showDialog(
          //   //   context: context,
          //   //   builder: (context) {
          //   //     return AlertDialog(
          //   //       title: const Text("InitState On Http Error"),
          //   //       content: Text(error.response?.statusCode.toString() ?? ""),
          //   //     );
          //   //   },
          //   // );
          //   // print(error.toString());
          // },
          onWebResourceError: (WebResourceError error) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(error.description.toString()),
            //   ),
            // );
            print(error);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains(widget.url ?? '')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      );

      await globalWebViewController
          .loadRequest(Uri.parse(widget.url ?? CHORD_URI));
    });
  }

  @override
  void didUpdateWidget(covariant Apps oldWidget) {
    // print("didUpdateWidget hit");
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      print("new widget");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: "(${widget.title})"),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 4,
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                  ),
                ),
                Expanded(
                  child: WebViewWidget(controller: globalWebViewController),
                ),
              ],
            ),
            Visibility(
              visible: isBackButtonVisible,
              child: Positioned(
                bottom: 20,
                left: 10,
                child: FloatingActionButton.extended(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  label: const Text("Back"),
                  onPressed: () {
                    if (isBackButtonVisible) {
                      globalWebViewController.goBack();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
