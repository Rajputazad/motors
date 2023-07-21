import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final logger = Logger();
  late List<Map<String, dynamic>> cardata = [];
  final apiurl = dotenv.get('API_URL');
  final getcae = dotenv.get('API_URL_GET');
  final color = const Color.fromARGB(255, 0, 102, 185);
  @override
  void initState() {
    getcar();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getcar() async {
    var url = Uri.parse(apiurl + getcae);
    var result = await http.get(url);
    if (result.statusCode == 200) {
      var data = jsonDecode(result.body);

      setState(() {
        var jsonData = data["data"];
        cardata = jsonData.cast<Map<String, dynamic>>();
        // logger.d(data["data"]);
      });
    }
    // logger.d(apiurl);
    // print(apiurl);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final listViewHeight = screenHeight - 80;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Replace with your desired app bar color
        // title: const Text('My App'),
        elevation: 0.1,
        actions: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "My app",
                    style: TextStyle(fontSize: 20, color: color),
                  ),
                ),
                // Spacer(),
                Container(
                  constraints: const BoxConstraints(maxWidth: 200.0),
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: color),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 231, 229, 229),
                      prefixIcon: Icon(
                        Icons.search,
                        color: color,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      // on();
                      // Handle search query submitted
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Material(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          //   // child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight - 80,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cardata.length,
                    itemBuilder: (BuildContext context, int index) {
                      final car = cardata[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10, right: 10),
                        child: Card(
                          elevation: 2, // Set the elevation for the card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set the border radius for the card
                          ),
                          child: SizedBox(
                            // color: Colors.amber,
                            width: 410,
                            height: 80,
                            // child: Expanded(
                            child: Row(
                              children: [
                                // Expanded(

                                SizedBox(
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Set the border radius value
                                    child:car["imagedetails"] != null && car["imagedetails"].isNotEmpty
    ? Image.network(car["imagedetails"][0]["url"])
    : Image.asset('assets/images/1.jpeg'), // Replace with your image asset path
                                  ),
                                ),
                                // child: Image(image: AssetImage("assets/images/1.jpeg")),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    height: 80,
                                    width: 170,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: SizedBox(
                                            height: 32,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                car["carname"],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: color,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                // textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            '${car['kilometers']} + ${car['fuel']} + ${car['transmission']}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: color,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(car['price'],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
