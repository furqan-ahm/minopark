import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minopark/controllers/game_controller.dart';
import 'package:minopark/services/client_service.dart';
import 'package:minopark/ui/discover_screen.dart';
import 'package:minopark/ui/game_screen.dart';
import '../services/host_service.dart';

class StartScreen extends GetView<GameController> {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(11))),
                child: TextField(
                  controller: controller.playerName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      labelText: 'Name'),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // Ink(
            //   decoration: const BoxDecoration(
            //       color: Colors.white,
            //       gradient: LinearGradient(
            //         colors: [
            //           Color.fromARGB(255, 252, 248, 248),
            //           Color.fromARGB(255, 253, 253, 253)
            //         ],
            //       ),
            //       shape: BoxShape.circle),
            //   child: InkWell(
            //     splashColor: const Color.fromARGB(52, 2, 247, 255),
            //     customBorder: const CircleBorder(),
            //     onTap: () {
            //       controller.startGame(isHost: true);
            //     },
            //     child: Container(
            //         padding: const EdgeInsets.all(80),
            //         child: const Text(
            //           'Host',
            //           style: const TextStyle(
            //             fontSize: 24,
            //           ),
            //         )),
            //   ),
            // ),
            ElevatedButton(
                onPressed: () {
                  controller.hostGame();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Host',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black
                    ),
                  ),
                )),
            const CustomDivider(),
            ElevatedButton(
                onPressed: () {
                  controller.joinGme(address: "192.168.137.87");
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Join',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black
                    ),
                  ),
                )),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Colors.white,
              thickness: 1,
              height: 2,
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'OR',
                style: TextStyle(color: Colors.white),
              )),
          const Expanded(
            child: Divider(
              color: Colors.white,
              thickness: 1,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
