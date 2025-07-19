import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'base_layout.dart';
import 'providers/realtime_data_provider.dart';
import 'providers/device_status_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Login Anonymous ke Firebase Authentication
  await _signInAnonymously();

  runApp(const MyApp());
}

Future<void> _signInAnonymously() async {
  try {
    await FirebaseAuth.instance.signInAnonymously();
    debugPrint("✅ Login anonymous berhasil");
  } catch (e) {
    debugPrint("❌ Login anonymous gagal: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RealtimeDataProvider()),
        ChangeNotifierProvider(create: (_) => DeviceStatusProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Irrigation Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const BaseLayout(),
      ),
    );
  }
}
