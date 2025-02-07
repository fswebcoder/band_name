import 'package:band_name/models/band.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Band> bands = [
    Band(id: "1", name: 'Metallica', votes: 4),
    Band(id: "2", name: 'Queen', votes: 3),
    Band(id: "3", name: 'Mago de oz', votes: 8),
    Band(id: "4", name: 'Bon jovi', votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title:
            const Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) =>
            _bandTile(bands[index]),
      ),
    );
  }

  ListTile _bandTile(Band banda) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(banda.name.substring(0, 2)),
      ),
      title: Text(banda.name),
      trailing: Text('${banda.votes}', style: const TextStyle(fontSize: 20)),
      onTap: () {
        print(banda.name);
      },
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name:'),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Band name',
              ),
            ),
            actions: [
              MaterialButton(
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () {
                    print(textController.text);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }
}
