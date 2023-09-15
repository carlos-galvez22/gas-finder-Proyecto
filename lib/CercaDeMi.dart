import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'Components/MenuList.dart';

class CercadeMi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.senTextTheme(),
      ),
      home: Scaffold(
        body: DrawerMenu()
        )
    );
  }
}
/*Drawer*/
class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}
class _DrawerMenuState extends State<DrawerMenu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      key: _scaffoldKey,
      body:Center(
        child: Stack(
          children: [
            MapsFlutter(),
            Positioned(
              top: 50,
              left: 250,
              right: 0,
              child: MenuBar(_scaffoldKey),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            bottomLeft: Radius.circular(60),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el cajón lateral
                  },
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 80,),
            Align(
              alignment: Alignment.bottomCenter,
              child: MenuList("CercadeMi"),
            )
          ],
        ),
      ),
    );
  }
}
class MenuBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  MenuBar(this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return Center(
        child:Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Color de la sombra
                spreadRadius: 0.5, // Extensión de la sombra
                blurRadius: 6, // Desenfoque de la sombra
                offset: Offset(0, 4), // Desplazamiento de la sombra
              ),
            ],// Borde redondeado
          ),
          constraints: BoxConstraints(
            maxHeight: 65, // Altura máxima del Container
            minHeight: 65, // Altura mínima del Container
            maxWidth: 65,

          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                child: Icon(Icons.menu, color: Colors.black),
              ),
            ],
          ),
        )
    );
  }
}
/*End Drawer*/

/*Maps*/
class MapsFlutter extends StatefulWidget {
  @override
  _MapsFlutterState createState() => _MapsFlutterState();
}
class _MapsFlutterState extends State<MapsFlutter> {
  Future<LatLng?>? myPositionFuture;

  @override
  void initState() {
    super.initState();
    myPositionFuture = getCurrentLocation();
  }
  Future<Position> DeterminePosition() async {

    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission==LocationPermission.denied) {
      permission=await Geolocator.requestPermission();
      if (permission==LocationPermission.denied) {
        return Future.error("Denied Permission of location in device");
      }
    }
    return await Geolocator.getCurrentPosition();
  }
  Future<LatLng?> getCurrentLocation() async {
    Position position = await DeterminePosition();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LatLng?>(
        future: myPositionFuture,
        builder: (context, snapshot) {
          LatLng? myPosition = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError || myPosition == null) {
            return Text('Error: No se pudo obtener la ubicación.');
          } else {
            return  FlutterMap(
              options: MapOptions(
                center: myPosition,
                zoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                  'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80,
                      height: 80,
                      point: myPosition, // Puedes establecer las coordenadas que desees
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Muestra información cuando se toca el marcador
                          showDialog(
                            context: ctx,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Hola!',style:TextStyle(fontWeight: FontWeight.bold)),
                                content:Container(
                                  height: 50,
                                  child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Esta es tu ubicacion actual",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                                    SizedBox(height: 1,),
                                  ],
                                ),
                              ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cerrar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/maps/location.png", // Reemplaza con la ubicación real de tu imagen de gasolinera
                              width: 40, // Ancho de la imagen
                              height: 40, // Altura de la imagen
                            ),
                          ],
                        ),
                      ),
                    ),
                    Marker(
                      width: 80,
                      height: 80,
                      point: LatLng(myPosition.latitude-0.007,myPosition.longitude), // Puedes establecer las coordenadas que desees
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Muestra información cuando se toca el marcador
                          showDialog(
                            context: ctx,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Gasolinera Puma Mejicanos',style:TextStyle(fontWeight: FontWeight.bold)),
                                content:Container(
                                  height: 100,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Direccion:"),
                                      SizedBox(height: 1,),
                                      Text("Av Prueba Calle Prueba",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                                      SizedBox(height: 8,),
                                      Text("Calificacion:"),
                                      RatingBar.builder(
                                        initialRating: 4, // Puntuación inicial (puedes cambiarlo según tus necesidades)
                                        minRating: 1, // Valor mínimo permitido
                                        direction: Axis.horizontal, // Dirección de las estrellas (horizontal o vertical)
                                        allowHalfRating: true, // Permitir calificaciones medias (0.5, 1.5, 2.5, etc.)
                                        itemCount: 5, // Número total de estrellas
                                        itemSize: 25, // Tamaño de cada estrella
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber, // Color de las estrellas llenas
                                        ),
                                        onRatingUpdate: (rating) {
                                          // Acción cuando el usuario intenta cambiar la calificación
                                        },
                                        ignoreGestures: true, // Hace que el widget sea no editable
                                      )

                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cerrar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/maps/gas.png", // Reemplaza con la ubicación real de tu imagen de gasolinera
                              width: 40, // Ancho de la imagen
                              height: 40, // Altura de la imagen
                            ),
                          ],
                        ),
                      ),
                    ),
                    Marker(
                      width: 80,
                      height: 80,
                      point: LatLng(myPosition.latitude-0.007,myPosition.longitude-0.007), // Puedes establecer las coordenadas que desees
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Muestra información cuando se toca el marcador
                          showDialog(
                            context: ctx,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Gasolinera Texaco El progreso',style:TextStyle(fontWeight: FontWeight.bold)),
                                content:Container(
                                  height: 100,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Direccion:"),
                                      SizedBox(height: 1,),
                                      Text("Av Prueba2 Calle Prueba2",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                                      SizedBox(height: 8,),
                                      Text("Calificacion:"),
                                      RatingBar.builder(
                                        initialRating: 2.5, // Puntuación inicial (puedes cambiarlo según tus necesidades)
                                        minRating: 1, // Valor mínimo permitido
                                        direction: Axis.horizontal, // Dirección de las estrellas (horizontal o vertical)
                                        allowHalfRating: true, // Permitir calificaciones medias (0.5, 1.5, 2.5, etc.)
                                        itemCount: 5, // Número total de estrellas
                                        itemSize: 25, // Tamaño de cada estrella
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber, // Color de las estrellas llenas
                                        ),
                                        onRatingUpdate: (rating) {
                                          // Acción cuando el usuario intenta cambiar la calificación
                                        },
                                        ignoreGestures: true, // Hace que el widget sea no editable
                                      )

                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cerrar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/maps/gas.png", // Reemplaza con la ubicación real de tu imagen de gasolinera
                              width: 40, // Ancho de la imagen
                              height: 40, // Altura de la imagen
                            ),
                          ],
                        ),
                      ),
                    ),
                    Marker(
                      width: 80,
                      height: 80,
                      point: LatLng(myPosition.latitude-0.005,myPosition.longitude-0.0012), // Puedes establecer las coordenadas que desees
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Muestra información cuando se toca el marcador
                          showDialog(
                            context: ctx,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Gasolinera UNO Atlacatl',style:TextStyle(fontWeight: FontWeight.bold)),
                                content:Container(
                                  height: 100,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Direccion:"),
                                      SizedBox(height: 1,),
                                      Text("Av Prueba3 Calle Buena Vista",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                                      SizedBox(height: 8,),
                                      Text("Calificacion:"),
                                      RatingBar.builder(
                                        initialRating: 4.5, // Puntuación inicial (puedes cambiarlo según tus necesidades)
                                        minRating: 1, // Valor mínimo permitido
                                        direction: Axis.horizontal, // Dirección de las estrellas (horizontal o vertical)
                                        allowHalfRating: true, // Permitir calificaciones medias (0.5, 1.5, 2.5, etc.)
                                        itemCount: 5, // Número total de estrellas
                                        itemSize: 25, // Tamaño de cada estrella
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber, // Color de las estrellas llenas
                                        ),
                                        onRatingUpdate: (rating) {
                                          // Acción cuando el usuario intenta cambiar la calificación
                                        },
                                        ignoreGestures: true, // Hace que el widget sea no editable
                                      )

                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cerrar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/maps/gas.png", // Reemplaza con la ubicación real de tu imagen de gasolinera
                              width: 40, // Ancho de la imagen
                              height: 40, // Altura de la imagen
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

/*End Maps*/