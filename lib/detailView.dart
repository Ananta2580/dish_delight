import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailView extends StatefulWidget {

  String fUrl;
  DetailView(this.fUrl, {super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      widget.fUrl = widget.fUrl.contains("http:")
          ? widget.fUrl.replaceAll("http:", "https:")
          : widget.fUrl;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: WebViewController()
            
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.fUrl))
        
        ),
      ),
    );
  }
}
