import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:editor_app/model/pdf_model.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

import '../repositories/pdf_repository.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  final PdfRepository _pdfRepository;
  PdfBloc(this._pdfRepository) : super(PdfInitial()) {
    on<PdfEvent>((event, emit) {});
    on<PdfLoadEvent>(_onLoad);
    on<PdfCreateEvent>(_onCreate);
    on<PdfDeleteEvent>(_onDelete);
    on<PdfUpdateEvent>(_onUpdate);
  }

  Future<FutureOr<void>> _onLoad(
      PdfLoadEvent event, Emitter<PdfState> emit) async {
    emit(PdfLoading());
    try {
      final pdfs = await _pdfRepository.getPdfs();
      emit(PdfLoaded(pdfs));
    } catch (e) {
      emit(PdfError());
    }
  }

  FutureOr<void> _onCreate(PdfCreateEvent event, Emitter<PdfState> emit) {}

  FutureOr<void> _onUpdate(PdfUpdateEvent event, Emitter<PdfState> emit) {}

  FutureOr<void> _onDelete(PdfDeleteEvent event, Emitter<PdfState> emit) {}
}
