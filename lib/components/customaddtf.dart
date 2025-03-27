import 'package:flutter/material.dart';

class Customaddtf extends StatelessWidget {
  final String hintText ;
  final TextEditingController Mycontroller ;
  final String? Function(String?)? validator;
  const Customaddtf({super.key , required this.hintText , required this.Mycontroller,required this.validator});

  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      validator:validator ,
                  controller: Mycontroller,
                  decoration: InputDecoration(
                    hintText: hintText ,
                      hintStyle: TextStyle(fontSize: 13 , color: Colors.grey[400]),
                    contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 9),
                    filled:  true ,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                    )
                  ),
         );
  }
}