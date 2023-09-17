// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:file_picker/file_picker.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({
    Key? key,
    this.width,
    this.height,
    required this.content,
    required this.html,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String content;
  final bool html;

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController();
    if (widget.html) {
      controller..setJavaScriptMode(JavaScriptMode.unrestricted);
      controller.loadHtmlString(widget.content);
    } else {
      controller..setJavaScriptMode(JavaScriptMode.unrestricted);
      controller.loadRequest(Uri.parse(widget.content));
    }

    addFileSelectionListener();
    super.initState();
  }

  void addFileSelectionListener() async {
    if (Platform.isAndroid) {
      final androidController = controller.platform as AndroidWebViewController;
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width ?? MediaQuery.sizeOf(context).width,
        height: widget.height ?? MediaQuery.sizeOf(context).height,
        child: WebViewWidget(controller: controller));
  }

  /// Function for file selection from gallery
  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      return [file.uri.toString()];
    }
    return [];
  }
}
