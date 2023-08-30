import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

dynamic dialog(BuildContext context, String title, String number) async {
  return await showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ClassicGeneralDialogWidget(
        // titleText: title,
        // contentText: number,
        // onPositiveClick: () {
        //   Text("Ok");
        //   Navigator.of(context).pop(true);
        // },
        // onNegativeClick: () {
        //   Navigator.of(context).pop(false);
        // },
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              // color: Colors.blue,
              width: 300,
              // height: 200,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Contact",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Manoj B. Rajput:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          const SelectableText("+919998497224"),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  "+919998497224"); // Replace the phone number with the desired number
                            },
                            icon: const Icon(Icons.phone),
                            color: Colors.green,
                            // iconSize: 48.0,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Chetan patel:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const SelectableText("+919898750901"),
                          const SizedBox(
                            width: 16,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  "+919898750901"); // Replace the phone number with the desired number
                            },
                            icon: const Icon(Icons.phone),
                            color: Colors.green,
                            // iconSize: 48.0,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Manoj patel:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const SelectableText("+917096991347"),
                          const SizedBox(
                            width: 17,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  "+917096991347"); // Replace the phone number with the desired number
                            },
                            icon: const Icon(Icons.phone),
                            color: Colors.green,
                            // iconSize: 48.0,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red)),
                        onPressed: () {
                          // Perform some action
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //  ElevatedButton(
          //   style:ButtonStyle (backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          //   onPressed: () {
          //     // Perform some action
          //     Navigator.of(context).pop(true);
          //   },
          //   child: const Text('Yes'),
          //   // style: ButtonStyle(backgroundColor: ),
          // ),
        ],
      );
    },
    animationType: DialogTransitionType.slideFromTopFade,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(milliseconds: 300),
  );
}
