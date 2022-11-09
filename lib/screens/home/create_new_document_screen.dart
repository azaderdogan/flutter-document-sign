import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../bloc/document_bloc.dart';

class CreateNewDocumentScreen extends StatelessWidget {
  const CreateNewDocumentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create a New Document'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Save Document'),
                      content:
                          Text('Are you sure you want to save this document?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context
                                .read<DocumentBloc>()
                                .add(DocumentSaveEvent());
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
        body: BlocListener<DocumentBloc, DocumentState>(
          listener: (context, state) {
            if (state is DocumentSaved) {
              Navigator.of(context)
                  .pushNamed('/pdf-preview', arguments: state.file);
            } else if (state is DocumentError) {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.message),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                quill.QuillToolbar.basic(
                    controller: context.read<DocumentBloc>().quillController),
                Expanded(
                  child: Container(
                    child: quill.QuillEditor.basic(
                      controller: context.read<DocumentBloc>().quillController,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
