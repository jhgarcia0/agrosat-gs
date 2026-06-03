import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/injection.dart';
import 'core/theme.dart';
import 'presentation/viewmodels/region_list_viewmodel.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  setupInjection();
  runApp(const AgroSatApp());
}

class AgroSatApp extends StatelessWidget {
  const AgroSatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<RegionListViewModel>()),
      ],
      child: MaterialApp(
        title: 'AgroSat',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
