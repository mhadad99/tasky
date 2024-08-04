import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:todo_app_task/modules/screens/task_details/task_details_screen.dart';
import 'package:todo_app_task/shared/components/components.dart';

class QrScanner extends StatelessWidget {
  const QrScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MobileScanner(
        fit: BoxFit.cover,
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {}
          if (barcodes.isNotEmpty) {
            print(barcodes.first.displayValue);
            navigateAndFinish(context, TaskDetailsScreen(id: 'id'));
          }
        },
      ),
    );
  }
}
