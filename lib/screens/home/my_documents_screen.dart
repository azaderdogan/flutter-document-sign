import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/pdf_bloc.dart';

class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PdfBloc>().add(PdfLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PdfBloc, PdfState>(
        builder: (context, state) {
          if (state is PdfLoaded) {
            return ListView.builder(
              itemCount: state.pdfs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.pdfs[index].title),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
