import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:minopark/controllers/game_controller.dart';
import 'package:minopark/ui/start_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flame Multiplayer Demo',
      initialBinding: GlobalBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black
      ),
      home: const StartScreen(),
    );
  }
}


class GlobalBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(GameController());
  }
}
