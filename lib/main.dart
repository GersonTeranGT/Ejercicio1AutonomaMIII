import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main (){
  runApp(ListaExterna());
}

class ListaExterna extends StatelessWidget {
  const ListaExterna({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Cuerpo(),
    );
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista externa"),),
      body: Column(
        children: [
          Text("Lista de depositos"),
          imgPortada(),
          Flexible(child: listaExterna()),
      ],),
    );
  }
}

//leer json externo
Future<List> leer(String url) async {
  final respuesta = await http.get(Uri.parse(url));

  return json.decode(respuesta.body);
}

//lista externa
Widget listaExterna(){
  String url = "https://jritsqmet.github.io/web-api/depositos.json";
  return FutureBuilder(future: leer(url), builder: (context, snapshot) {
    if (snapshot.hasData) {
      
      final data = snapshot.data!;
      return ListView.builder( itemCount: data.length, itemBuilder:(context, index) {
        final item = data[index];
        return Card(
          color: const Color.fromARGB(255, 26, 141, 70),
          child: ListTile(
            title: Text(item['id']),
            subtitle: Text(item['banco']),
            //leading: Image.network(item['media']['cover_image']),
            
            trailing: IconButton(onPressed: ()=> verMas(context, item), icon: Icon(Icons.more)),
            //() => verMas(context, item),
          ),
        );
      },);

    }else{
      return (CircularProgressIndicator());
    }
  },);
}


//modal
void verMas(BuildContext context, Map item){
  showDialog(context: context, builder: (context) => 
    AlertDialog(
      title: Text(item['detalles']['método_pago']),
      content: Column(
        children: [
          Text("Banco: ${item['banco_origen']}"),
          Text("Monto: ${item['monto']}"),
          Text("Fecha: ${item['fecha']}"),
          
        ],),
    )
  ,);
}
Widget imgPortada(){
  return (
    Image.asset("assets/image/deposito.jpg",)
  );
}