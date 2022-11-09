import 'dart:io';

import 'package:editor_app/bloc/pdf_bloc.dart';
import 'package:editor_app/firebase_options.dart';
import 'package:editor_app/repositories/firebase_auth_repository.dart';
import 'package:editor_app/repositories/pdf_repository.dart';
import 'package:editor_app/screens/authetication/login_screen.dart';
import 'package:editor_app/screens/home/create_new_document_screen.dart';
import 'package:editor_app/screens/home/home_screen.dart';
import 'package:editor_app/screens/home/my_documents_screen.dart';
import 'package:editor_app/screens/home/pdf_preview_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication_bloc.dart';
import 'bloc/document_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirebaseAuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(FirebaseAuthRepository()),
          ),
          BlocProvider(
            create: (context) => PdfBloc(PdfRepository()),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                );
              case '/login':
                return MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                );
              case '/documents':
                return MaterialPageRoute(
                  builder: (context) => const MyDocumentsScreen(),
                );
              case '/new-document':
                return MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => DocumentBloc(),
                    child: CreateNewDocumentScreen(),
                  ),
                );
              case '/pdf-preview':
                return MaterialPageRoute(
                  builder: (context) => PdfPreviewScreen(
                    file: settings.arguments as File,
                  ),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                );
            }
          },
        ),
      ),
    );
  }
}
