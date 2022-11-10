part of 'pdf_bloc.dart';

@immutable
abstract class PdfState extends Equatable {}

class PdfInitial extends PdfState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PdfLoading extends PdfState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PdfLoaded extends PdfState {
  final List<PdfModel> pdfs;

  PdfLoaded(this.pdfs);

  @override
  // TODO: implement props
  List<Object?> get props => [pdfs];
}

class PdfError extends PdfState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PdfUploaded extends PdfState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
