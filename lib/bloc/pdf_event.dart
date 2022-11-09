part of 'pdf_bloc.dart';

@immutable
abstract class PdfEvent {}

class PdfLoadEvent extends PdfEvent {}

class PdfCreateEvent extends PdfEvent {}

class PdfDeleteEvent extends PdfEvent {}

class PdfUpdateEvent extends PdfEvent {}

