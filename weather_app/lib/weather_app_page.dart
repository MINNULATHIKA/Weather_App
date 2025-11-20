import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:weather_app/additional_info_items.dart';
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';
import 'hourly_forcast_items.dart';
import 'package:http/http.dart' as http;

class weatherAppPage extends StatefulWidget {
  const weatherAppPage({super.key});

  @override
  State<weatherAppPage> createState() => _weatherAppPageState();
}

class _weatherAppPageState extends State<weatherAppPage> {

late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async {  // here return data structured like a map where keys are string and data mapped is string/integer/decimal , so second should be dynamic
    try {
      String cityName = 'London';
      final res = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherApiKeys'));
    final data = jsonDecode(res.body);
    if(data['cod'] != '200'){
      throw 'an error occured';
    }
      // temp = data['list'][0]['main']['temp'];
return data;

    }
    catch(e){
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();  // by assigning getCurrentWeather() to a variable it builds only once in initState() , and this variable is calling multiple times in futureBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Weather App',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            // GestureDetector(
            //     onTap: (){},
            //     child: const Icon(Icons.refresh))  we need to set padding if we follow GestureDetector
            IconButton(onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            }, icon: Icon(Icons.refresh))
          ],
        ),
        body:FutureBuilder(
            future: weather,
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.active){
                return const Center(child:  CircularProgressIndicator.adaptive());
              }
              if(snapshot.hasError){
                return Center(child: Text(snapshot.error.toString()));
              }
              final data = snapshot.data;  // ! indicates not null
              final currentTemp = data?['list'][0]['main']['temp'];
              final currentSky = data?['list'][0]['weather'][0]['main'];
              final currentPressure = data?['list'][0]['main']['pressure'];
              final currentWind = data?['list'][0]['wind']['speed'];
              final currentHumidity = data?['list'][0]['main']['humidity'];


              return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10, // giving a 3D effect , more clear and accurate structure
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ClipRRect( // adding its own border radius , separates blurred effect from back ground
                    borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(  // adding a blurred effect
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10
                    ),
                  child:  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                  children: [
                    Text(
                      '$currentTemp K',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                     SizedBox(height: 16),
                    Icon((currentSky == 'Rain' || currentSky == 'Cloud') ? Icons.cloud : Icons.sunny,size: 64,),
                     SizedBox(height: 16),
                    Text('$currentSky',style: TextStyle(fontSize: 20),)
                  ],
                ))
        )
                  )),
              ),
              const SizedBox(height: 20),
              const Text('Hourly Forecast', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              //  SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              // child:Row(
              //   children: [
              //     for(int i = 0;i<39;i++)
              //     HourlyForcastItems(time: data['list'][i+1]['dt'].toString(),icon: data['list'][0]['weather'][0]['main'] == 'Clouds' || data['list'][0]['weather'][0]['main'] == 'Rain' ? Icons.cloud : Icons.sunny,value: data['list'][i+1]['main']['temp'].toString()),
              //   ],
              // ),),
// instead of building all blocks like above in loop , we can implement lazy loading with list builder
            SizedBox(
              height: 130,
            child:ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
              final hourlyForecast =  data?['list'][index+1];
              final hourlySky = data?['list'][index+1]['weather'][0]['main'];
              final hourlyTemp = data?['list'][index+1]['main']['temp'];
              final time = DateTime.parse(hourlyForecast['dt_txt']);
               return   HourlyForcastItems(time: DateFormat.j().format(time),icon: hourlySky == 'Clouds' || hourlySky == 'Rain' ? Icons.cloud : Icons.sunny,value: hourlyTemp.toString());
            })),
              const SizedBox(height: 20),
              const Text('Additional information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItems(icon:Icons.water_drop,label: 'humidty',value: currentHumidity.toString()),
                  AdditionalInfoItems(icon:Icons.air,label: 'Wind speed',value: currentWind.toString()),
                  AdditionalInfoItems(icon:Icons.beach_access,label: 'Pressure',value: currentPressure.toString())
                ]
              ),
            ],
          ),
        );}));
  }
} 