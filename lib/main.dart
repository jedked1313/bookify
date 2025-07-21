import 'package:bookify/app/router.dart';
import 'package:bookify/providers/auth_provider.dart';
import 'package:bookify/providers/book_provider.dart';
import 'package:bookify/providers/rental_provider.dart';
import 'package:bookify/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  runApp(Bookify(authProvider: authProvider));
}

class Bookify extends StatelessWidget {
  final AuthProvider authProvider;
  const Bookify({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeData.light())),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) {
          final provider = BookProvider();
          provider.loadBooks();
          return provider; // Ensure books are loaded on startup
        }),
        ChangeNotifierProvider(create: (_) {
          final provider = RentalProvider();
          provider.loadRentals();
          return provider; // Ensure rentals are loaded on startup
        }),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, themeProvider, Widget? child) {
          return MaterialApp.router(
            title: 'Bookify',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            themeMode: Provider.of<ThemeProvider>(context, listen: false)
                        .themeData
                        .brightness ==
                    Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme:
                Provider.of<ThemeProvider>(context, listen: false).lightTheme,
            darkTheme:
                Provider.of<ThemeProvider>(context, listen: false).darkTheme,
          );
        },
      ),
    );
  }
}
