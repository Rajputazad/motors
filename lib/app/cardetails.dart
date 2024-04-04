import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:motors/tools/image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:motors/tools/dailog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:open_file/open_file.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flowder/flowder.dart';
// import 'package:percent_indicator/percent_indicator.dart';

class Cardetails extends StatefulWidget {
  final String id;
  const Cardetails({super.key, required this.id});

  @override
  State<Cardetails> createState() => _CardetailsState();
}

class _CardetailsState extends State<Cardetails> {
  bool down = false;
  final logger = Logger();
  final apiurl = dotenv.get('API_URL');
  final getcar = dotenv.get('API_URL_GETCAR');
  final color = const Color.fromARGB(255, 0, 102, 185);
  //  = [
  //   // Add URLs or local paths of your images here
  //   'https://ik.imagekit.io/b4x27zdza/Uday_Motors/file_FgnuqrHaj3.jpeg',
  //   'https://ik.imagekit.io/b4x27zdza/Uday_Motors/file_FgnuqrHaj3.jpeg',
  //   'https://ik.imagekit.io/b4x27zdza/Uday_Motors/file_FgnuqrHaj3.jpeg',
  //   'https://ik.imagekit.io/b4x27zdza/Uday_Motors/file__10__k_Nljh3d2J.jpeg',

  //   // Add more images as needed
  // ];
  int activePage = 0;
  final PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);
  @override
  void initState() {
    car(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatAmountInRupees(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatCurrency.format(amount);
  }

  bool loding = true;
  dynamic cardetals;
  late List<String> images = [];
  car(id) async {
    var url = Uri.parse(apiurl + getcar + id);
    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() {
          loding = false;
          cardetals = jsonDecode(res.body);
          cardetals = cardetals["data"];
        });
        logger.d(cardetals["imagedetails"].toString().runtimeType);
        var nestedArray = cardetals["imagedetails"] as List<dynamic>;
        images = nestedArray.map((item) => item['url'].toString()).toList();
        // logger.d(images);
      }
    } catch (e) {
      loding = true;

      logger.d(e);
    }
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 0 : 15;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(images[pagePosition]))),
    );
  }

  void _showImageFullScreen(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageGallery(
          images: images,
          initialIndex: index,
          car: cardetals["carname"],
        ),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  Future<void> _shareData(BuildContext context) async {
    // Gather the data to share (images and details)
    String textToShare =
        "carurl:-${images[0]} Car:-${cardetals['carname']} Please check out our app for more details";
    // for (int i = 0; i < images.length; i++) {
    //   textToShare += 'Image URL: ${images[i]}\nDetail: ${cardetals[i]}\n\n';
    // }

    // Share the data using the share_plus package
    await Share.share(textToShare);
  }

  // ignore: unused_field
  late double? _progress;

  Future<void> _downloadImage() async {
    setState(() {
      down = true;
    });
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      // Permission granted. You can now save files to external storage.
      //  logger.d(images[0]);
      try {
        for (int i = 0; i < images.length; i++) {
          await FileDownloader.downloadFile(
              url: images[i],
              onProgress: (name, progress) {
                setState(() {
                  _progress = progress;
                  down = false;
                });
              },
              onDownloadCompleted: (value) {
                logger.d(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Image downloaded successfully.')),
                );
              });
        }
      } on Exception catch (e) {
        logger.d(e);
        down = false;

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error downloading image.')),
        );
      }
    } else {
      // Permission denied. Handle this situation accordingly.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission not granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final Color containerColor =
        brightness == Brightness.light ? Colors.white : Colors.black;
    final Color logo =
        brightness == Brightness.light ? Colors.black : Colors.white;
    // return FutureBuilder(builder: (context, snapshot) {
    if (loding == true) {
      // While the future is still loading
      return Container(
          decoration: BoxDecoration(color: containerColor),
          child: Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: color,
              size: 40,
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          // foregroundColor: Colors.black,
          // backgroundColor: const Color.fromARGB(
          //     255, 255, 255, 255), // Replace with your desired app bar color
          // title: const Text('My App'),
          elevation: 0.1,
          actions: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    cardetals["carname"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  // Text(cardetals["transmission"])
                ],
              ),
            ))
          ],
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: PageView.builder(
                          itemCount: images.length,
                          pageSnapping: true,
                          controller: _pageController,
                          onPageChanged: (page) {
                            setState(() {
                              activePage = page;
                            });
                          },
                          itemBuilder: (context, pagePosition) {
                            bool active = pagePosition == activePage;
                            return GestureDetector(
                                onTap: () {
                                  _showImageFullScreen(
                                    context,
                                    pagePosition,
                                  );
                                },
                                child: slider(images, pagePosition, active));
                          }),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indicators(images.length, activePage)),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 5),
                      child: SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: SelectableText(
                                formatAmountInRupees(
                                    double.parse(cardetals["price"])),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            // Spacer(),
                            // const SizedBox(width: 50),
                            IconButton(
                              icon: const Icon(Icons.location_on),
                              color: Colors.red,
                              onPressed: () async {
                                var latitude = '23.0090583';
                                var longitude = '72.6691394';
                                final url =
                                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

                                // ignore: deprecated_member_use
                                if (await canLaunch(url)) {
                                  // ignore: deprecated_member_use
                                  await launch(url);
                                  //  await launch(url, mode: LaunchMode.externalApplication);
                                } else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Could not launch Maps')),
                                  );
                                  // throw 'Could not launch $url';
                                }
                              },
                            ),
                            down
                                ? const SizedBox(
                                    width: 30, // Adjust the width as needed
                                    height: 30,
                                    child: CircularProgressIndicator())
                                : IconButton(
                                    icon: const Icon(Icons
                                        .file_download), // Use the appropriate download icon
                                    onPressed: () => _downloadImage(),
                                  ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => _shareData(context),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10),
                      child: SizedBox(
                        child: Divider(
                          height: 30,
                          thickness: 2,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(width: 4, color: Colors.black),
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.directions_car,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Model",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.center,
                                              child: SelectableText(
                                                  cardetals["model"])),
                                        ]),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: logo,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'km',
                                                      style: TextStyle(
                                                        // fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: containerColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8.0),
                                                const Text(
                                                  "Kilometers",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.center,
                                              child: SelectableText(
                                                  "${cardetals["kilometers"]}KM"))
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Center(
                                                  child: Icon(
                                                    Icons.build,
                                                    size: 20,
                                                    // color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Service",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["service"]))
                                        ]),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.person_add,
                                                  // size: 100,
                                                  // color: Colors.blue,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Registration",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["registration"]))
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  // size: 100,
                                                  // color: Colors.blue,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Owner",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["owner"]))
                                        ]),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.local_gas_station,
                                                  // size: 100,
                                                  // color: Colors.green,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Fuel",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["fuel"]))
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.description,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Numberplate",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["numberplate"]))
                                        ]),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.settings,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Transmission",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["transmission"]))
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.local_offer,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Insurance",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["insurance"]))
                                        ]),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.description,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Description",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                              // alignment: Alignment.centerLeft,
                                              child: SelectableText(
                                                  cardetals["description"]))
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Add more TableRow widgets for additional rows
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Positioned(
            bottom: 0.0,
            // right: 100.0,
            child: Container(
              color: containerColor,
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 151, 6)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the border radius
                        ),
                      ),
                    ),
                    onPressed: () async {
                      var title = "Contact";
                      var number = "+919998497224";
                      dynamic result = await dialog(context, title, number);
                      // await dialog(context, title, number);
                      // String telephoneNumber = '+2347012345678';
                      if (result == "+919998497224" ||
                          result == "+919898750901" ||
                          result == "+917096991347") {
                        String telephoneUrl = "tel:$result";
                        // ignore: deprecated_member_use
                        if (await canLaunch(telephoneUrl)) {
                          // ignore: deprecated_member_use
                          await launch(telephoneUrl);
                        } else {
                          throw "Error occured trying to call that number.";
                        }
                      } else {}
                    },
                    child: const Text(
                      "Book your Car",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      );

      // ]),
    }
    // });
  }
}
