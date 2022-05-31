import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Porter', votes: 1),
    Band(id: '2', name: 'Soda Stereo', votes: 3),
    Band(id: '3', name: 'Kinky', votes: 4),
    Band(id: '4', name: 'Juanes', votes: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("BandNames", style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {
          return _BandTile(band: bands[index]);
        }
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.add),
        onPressed: addNewBand
      ),
    );
  }

  addNewBand(){
    final textController = TextEditingController();

    if( Platform.isAndroid ){
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("New Band Name"),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: const Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList(textController.text)
              )
            ],
          );
        }
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: const Text("New Band Name"),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Add"), 
              onPressed: () => addBandToList(textController.text)
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Dismiss"), 
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }
    );

    
  }

  void addBandToList(String name){
    print(name);
    if(name.length > 1){
      bands.add(Band(
        id: DateTime.now().toString(), 
        name: name, 
        votes: 0
      ));
      setState(() {});
    } 

    Navigator.pop(context);
  }
}

class _BandTile extends StatelessWidget {
  const _BandTile({
    Key? key,
    required this.band,
  }) : super(key: key);

  final Band band;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ){
        print("Borrar ${band.name}");
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: const Align(
          child: Text("Delete Band", style: TextStyle(color: Colors.white),),
          alignment: Alignment.centerLeft,
        ),
      ),
      key: Key(band.id),
      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text( band.name ),
        trailing: Text( "${band.votes}", style: const TextStyle(fontSize: 20), ),
        onTap: (){
          print(band.name);
        },
      ),
    );
  }
}