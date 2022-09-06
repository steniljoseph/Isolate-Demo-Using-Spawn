import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Isolate Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Click to Start'),
              onPressed: () async {
                //ReceivePort is to listen for the isolate to finish job
                final receivePort = ReceivePort();
                // here we are passing method name and sendPort instance from ReceivePort as listener
                await Isolate.spawn(
                    computationallyHeavyTask, receivePort.sendPort);

                //It will listen for isolate function to finish
                receivePort.listen((sum) {
                  log(sum.toString());
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

void computationallyHeavyTask(SendPort sendPort) {
  log('heavy work started');
  var sum = 0;
  for (var i = 0; i <= 1000000000; i++) {
    sum += i;
  }
  log('heavy work finished');
  //Remember there is no return, we are sending sum to listener defined before.
  sendPort.send(sum);
}
