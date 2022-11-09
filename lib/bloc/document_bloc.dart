import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:delta_markdown/delta_markdown.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown/markdown.dart';
import 'package:path_provider/path_provider.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  QuillController quillController = QuillController.basic();

  DocumentBloc() : super(DocumentInitial()) {
    on<DocumentEvent>((event, emit) {});
    on<DocumentSaveEvent>(_onCreate);
  }
  String quillDeltaToHtml(Delta delta) {
    final convertedValue = jsonEncode(delta.toJson());
    final markdown = deltaToMarkdown(convertedValue);
    final html = markdownToHtml(markdown);

    return html;
  }

  Future<FutureOr<void>> _onCreate(
      DocumentSaveEvent event, Emitter<DocumentState> emit) async {
    try {
      emit(DocumentLoading());
      var delta = quillController.document.toDelta();
      var html = quillDeltaToHtml(delta);
      var directory = await getApplicationDocumentsDirectory();
      var file = await FlutterHtmlToPdf.convertFromHtmlContent(
          html, directory.path, 'targetName');
      emit(DocumentSaved(file));
    } catch (e) {
      debugPrint(e.toString());
      emit(DocumentError(e.toString()));
    }
  }
}
