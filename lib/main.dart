import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_management/bloc/invoice_bloc.dart';

import 'package:invoice_management/constants.dart';
import 'package:invoice_management/controllers/MenuAppController.dart';
import 'package:invoice_management/routes.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async {
  setPathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
          BlocProvider(
            create: (context) => InvoiceBloc()..add(InvoiceStarted()),
          ),
        ],
        child: MaterialApp.router(
          title: 'MoneyUp Invoice Manager',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            textTheme: GoogleFonts.poppinsTextTheme(),
            useMaterial3: true,
          ),
        ));
  }
}
