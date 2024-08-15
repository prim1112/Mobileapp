import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/model/response/trips.idx.get.res.dart';
import 'package:flutter_application_2/model/response/trips_get_res.dart';
import 'package:http/http.dart' as http;

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late TripsIdxGetRsesponse trip;
  late Future<void> loadData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: const CircularProgressIndicator());
            }
            return SingleChildScrollView(
                child: Column(
              children: [
                Text(trip.name),
                Text(trip.destinationZone),
                Image.network(trip.coverimage),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('ราคา ${trip.price} บาท'),
                    Text('โซน ${trip.destinationZone} '),
                  ],
                ),
                Text(trip.detail),
                FilledButton(onPressed: () {}, child: const Text('จองทริปนี้'))
              ],
            ));
          }),
    );
  }

  Future<void> loadDataAsync() async {
    var value = await Configuration.getConfig();
    String url = value['apiEndpoint'];

    var json = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    trip = tripsIdxGetRsesponseFromJson(json.body);
  }
}
