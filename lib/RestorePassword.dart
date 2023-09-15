
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gas_finder/Login.dart';
import 'package:google_fonts/google_fonts.dart';

class Restore extends StatefulWidget{
  @override
  _RestoreState createState() => _RestoreState();
}

class _RestoreState extends State<Restore>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.senTextTheme(),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color(0xff44587e),
                  Color(0xff3e4c6b),
                  Color(0xff303b52)
                ]
            ),
          ),
    child: Column(
      children: [
         SizedBox(height: 140,),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text("¿Olvidaste tu contraseña?",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text("Por favor ingresa una dirección de correo",style: TextStyle(color: Colors.white,fontSize: 15,),)
              ],
            ),
          ),
          Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 40,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffeebd3d),
                                shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text('Envíar'),
                        ),
                        SizedBox(height: 20),
                      ]
                    )
                  )
                )
          )
            ]
    )
      )
      )
      );
  }
}