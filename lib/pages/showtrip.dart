import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/response/trips_get_res.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/pages/trip.dart';
import 'package:flutter_application_2/model/response/trips_get_res.dart';
import 'package:http/http.dart' as http; //1.

class showtrip extends StatefulWidget {
  int idx = 0;
  showtrip({super.key, required this.idx});

  @override
  State<showtrip> createState() => _showtripState();
}

class _showtripState extends State<showtrip> {
  String url = '';
  List<TripGetResponse> trips = [];
  //3. ประกาศ object Async objeck
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    //การสร้าง object loadData from loadDataAsync()
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        idx: widget.idx,
                      ),
                    ));
              } else if (value == 'logout') {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text('ปลายทาง'),
                ),
              ],
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: FilledButton(
                          onPressed: () => getTrips(null),
                          child: const Text('ทั้งหมด')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: FilledButton(
                          onPressed: () => getTrips('เอเชีย'),
                          child: const Text('เอเชีย')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: FilledButton(
                          onPressed: () => getTrips('ยุโรป'),
                          child: const Text('ยุโรป')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: FilledButton(
                          onPressed: () => getTrips('เอเชียตะวันออกเฉียงใต้'),
                          child: const Text('อาเซียน')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: FilledButton(
                          onPressed: () => getTrips('ประเทศไทย'),
                          child: const Text('ประเทศไทย')),
                    )
                  ],
                )),
            Expanded(
              //1. รับด้วย FutureBuilder
              child: FutureBuilder(
                  //5. เรียก call funtion
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        //ดึงข้อมูลในแต่ละtrip ในแต่ละรอบ
                        children: trips
                            .map(
                              (trip) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(trip.name,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8.0, 3.0, 8.0, 3.0),
                                                child: SizedBox(
                                                    width: 150,
                                                    height: 150,
                                                    child: Image.network(
                                                      trip.coverimage,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('ประเทศ${trip.country}'),
                                                  Text(
                                                      'ระยะเวลา ${trip.duration} วัน'),
                                                  Text(
                                                      'ราคา ${trip.price} บาท'),
                                                  FilledButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                TripPage(
                                                                    idx: trip
                                                                        .idx),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'รายละเอียดเพิ่มเติม'))
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

// 2. โหลดข้อมูลจากapi
  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    var json = await http.get(Uri.parse('$url/trips'));
    trips = tripGetResponseFromJson(json.body);
    setState(() {
      
    });
  }

  void getTrips(String? zone) async {
    // 1. Create http
    // 1.1 Load url from config
    // 2. Call Get / trips
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];
    http.get(Uri.parse('$url/trips')).then(
      (value) {
        // 3. Put response data to model
        trips = tripGetResponseFromJson(value.body);
        List<TripGetResponse> filteredTrips = [];
        if (zone != null) {
          for (var trip in trips) {
            if (trip.destinationZone == zone) {
              filteredTrips.add(trip);
            }
          }
          trips = filteredTrips;
        }
        // 4. Log number of trips
        log(trips.length.toString());
        setState(() {});
      },
    );
  }
}
