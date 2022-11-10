import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:editor_app/model/pdf_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PdfRepository {
  PdfRepository();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PdfModel>> getPdfs() async {
    //fetch pdf from firestore
    final QuerySnapshot<Map<String, dynamic>> pdfs =
        await _firestore.collection('pdfs').get();

    final List<PdfModel> pdfList = pdfs.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> pdf) =>
            PdfModel.fromMap(pdf.data()))
        .toList();

    return pdfList;
  }

  Future<void> createPdf(PdfModel pdf) async {
    var url = await uploadPdf('title ', pdf.path!);
    pdf.url = url;
    //create pdf in firestore
    await _firestore.collection('pdfs').add(pdf.toMap());
  }
  //upload pdf to firebase storage

  Future<void> updatePdf(PdfModel pdf) async {
    //update pdf in firestore
    await _firestore.collection('pdfs').doc(pdf.title).update(pdf.toMap());
  }

  Future<void> deletePdf(PdfModel pdf) async {
    //delete pdf in firestore
    await _firestore.collection('pdfs').doc(pdf.title).delete();
  }

  Future<String> uploadPdf(String title, String path) async {
    //upload pdf to firebase storage
    final Reference ref = _storage.ref().child(title);
    final UploadTask uploadTask = ref.putFile(File(path));
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
