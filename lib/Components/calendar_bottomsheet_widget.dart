import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalndearButtomSheetWidget extends StatelessWidget {
  const CalndearButtomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: MediaQuery.of(context).size.height * (3 / 4) + bottomInset,
      child: Column(
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
