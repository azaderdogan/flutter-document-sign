import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../bloc/pdf_bloc.dart';

class PdfPreviewScreen extends StatefulWidget {
  File? file;
  PdfPreviewScreen.fromUrl({this.url, this.isLink = true});
  PdfPreviewScreen.fromFile({this.file, this.isLink = false});
  String? url;
  final bool isLink;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  late final PDFDocument document;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    !widget.isLink
        ? PDFDocument.fromFile(widget.file!).then((value) {
            setState(() {
              document = value;
              isLoading = false;
            });
          })
        : PDFDocument.fromURL(widget.url!).then((value) {
            setState(() {
              document = value;
              isLoading = false;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : PDFViewer(document: document),
    );
  }
}

class PdfViewer extends StatefulWidget {
  PdfViewer({this.file});

  File? file;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final controller = TextEditingController();
  Offset? _offset;
  bool isFixed = false;
  File? imageFile = File('');
  late File file;
  final _signatureController = SignatureController();
  Uint8List? _signatureBytes;
  int currentPage = 0;

  createFile() async {
    var dir = await getApplicationDocumentsDirectory();
    file = File('${dir.path}/doc.pdf');
    file.writeAsBytes(widget.file!.readAsBytesSync());
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    _signatureController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    file = widget.file!;
    createFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PdfBloc, PdfState>(
      listener: (context, state) {
        if (state is PdfUploaded) {
          EasyLoading.showSuccess('Uploaded');
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => false,
          );
        } else if (state is PdfError) {
          EasyLoading.showError('Error');
        } else if (state is PdfLoading) {
          EasyLoading.show(status: 'loading...');
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                  onTap: () {
                    setState(() {
                      isFixed = false;
                    });
                    showSignatureDialogue();
                  },
                  child: Icon(Icons.edit)),
              InkWell(
                  onTap: () {
                    context.read<PdfBloc>().add(PdfCreateEvent(widget.file!));
                  },
                  child: Icon(Icons.check)),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                PdfWidget(
                    file: file,
                    offset: _offset ?? Offset(37.5, 37.5),
                    signatureBytes: _signatureBytes,
                    isFixed: isFixed,
                    onComplete: (file) {
                      widget.file = file;
                    },
                    onDragEnd: (offset) {
                      _offset = offset;
                      setState(() {});
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showSignatureDialogue() {
    showDialog(
        context: context,
        builder: (c) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 100),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Signature(
                    controller: _signatureController,
                    width: 300,
                    height: 300,
                    backgroundColor: Colors.yellow.withOpacity(0.2),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _signatureController.clear();
                        },
                        child: Text('clear'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final exportController = SignatureController(
                            penStrokeWidth: 2,
                            penColor: Colors.black,
                            exportBackgroundColor: Colors.white,
                            points: _signatureController.points,
                          );

                          _signatureBytes = await exportController.toPngBytes();

                          exportController.dispose();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class PdfWidget extends StatefulWidget {
  PdfWidget({
    Key? key,
    this.signatureBytes,
    required this.file,
    required this.offset,
    required this.onDragEnd,
    required this.onComplete,
    required this.isFixed,
  }) : super(key: key);

  final Uint8List? signatureBytes;
  final File file;
  final Offset offset;
  final Function(Offset) onDragEnd;
  final Function(File file) onComplete;
  bool isFixed = false;

  @override
  State<PdfWidget> createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SfPdfViewer.file(
            widget.file,
            onPageChanged: (page) {
              currentPage = page.newPageNumber;
              setState(() {});
            },
          ),
        ),
        Visibility(
          visible: widget.signatureBytes != null && !widget.isFixed,
          child: Positioned(
            top: widget.offset.dy,
            left: widget.offset.dx,
            child: Draggable(
              childWhenDragging: Container(),
              feedback: Material(
                child: imageWidget(),
              ),
              onDragEnd: (details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                var offset = renderBox.globalToLocal(details.offset);
                widget.onDragEnd(offset);
                setState(() {});
              },
              child: Column(
                children: [
                  imageWidget(),
                  Visibility(
                    visible: !widget.isFixed,
                    child: InkWell(
                        onTap: () async {
                          final PdfDocument document = PdfDocument(
                              inputBytes: widget.file.readAsBytesSync());
                          final PdfBitmap image =
                              PdfBitmap(widget.signatureBytes!);
                          RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                          var offset = renderBox.localToGlobal(
                              Offset(widget.offset.dx, widget.offset.dy));

                          document.pages[currentPage].graphics.drawImage(
                              image, Rect.fromLTWH(300, 740, 100, 100));
                          var signedFile = await widget.file
                              .writeAsBytes(await document.save());
                          document.dispose();
                          widget.isFixed = true;
                          widget.onComplete(signedFile);
                          setState(() {});
                        },
                        child: Icon(
                          Icons.done,
                          size: 30,
                          color: Colors.blue,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget imageWidget() {
    if (widget.signatureBytes != null) {
      return Image.memory(
        widget.signatureBytes!,
        height: 50,
        width: 100,
        fit: BoxFit.contain,
      );
    } else
      return Container();
  }
}
