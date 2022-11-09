part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentSaved extends DocumentState {
  final File file;

  DocumentSaved(this.file);

  @override
  List<Object> get props => [file];
}

class DocumentError extends DocumentState {
  final String message;

  DocumentError(this.message);

  @override
  List<Object> get props => [message];
}
