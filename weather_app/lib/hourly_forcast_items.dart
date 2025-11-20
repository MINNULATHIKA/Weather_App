import 'package:flutter/material.dart';

class HourlyForcastItems extends StatelessWidget{
  final IconData icon;
  final String time;
  final String value;
  const HourlyForcastItems({super.key, required this.icon, required this.time, required this.value});

  @override
  Widget build(BuildContext context){
    return        Card(
        elevation: 6,
        child: Container(
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12)
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text(time, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              const SizedBox(height: 8),
              Icon(icon,size: 32),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            ],
          ),
        )
    );

  }
}
