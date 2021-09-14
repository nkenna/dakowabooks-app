import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class OpenBookScreen extends StatefulWidget {
  final String? bookPath;

  const OpenBookScreen({Key? key, this.bookPath}) : super(key: key);


  @override
  _OpenBookScreenState createState() => _OpenBookScreenState();
}

class _OpenBookScreenState extends State<OpenBookScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              onPressed: () {
                _pdfViewerKey.currentState?.openBookmarkView();
              },
            ),
          ],
        ),
        body: SfPdfViewer.file(
          File(widget.bookPath!),
          key: _pdfViewerKey,
            canShowPaginationDialog: true
        ),
      ),
    );
  }
}
