import 'package:band_name/models/band.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.on('active-bands', _handleActiveBands);

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket?.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _showGraph(),
          Expanded(
              child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) =>
                _bandTile(bands[index]),
          ))
        ],
      ),
    );
  }

  Dismissible _bandTile(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        final socketService =
            Provider.of<SocketService>(context, listen: false);
        socketService.socket?.emit('delete-band', {banda.id});
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(banda.name.substring(0, 2)),
        ),
        title: Text(banda.name),
        trailing: Text('${banda.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          final socketService =
              Provider.of<SocketService>(context, listen: false);
          socketService.socket?.emit('vote-band', {banda.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    final socketService = Provider.of<SocketService>(context, listen: false);

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
                    socketService.socket
                        ?.emit('register-band', {'name': textController.text});
                    Navigator.pop(context);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }
    if (dataMap.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(child: Text('No data available')),
      );
    }
    return SizedBox(
        width: double.infinity,
        height: 150,
        child: PieChart(
            animationDuration: const Duration(milliseconds: 800),
            centerText: dataMap.length > 1 ? '' : 'No data available',
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
            chartLegendSpacing: 32,
            ringStrokeWidth: 32,
            chartType: ChartType.ring,
            dataMap: dataMap));
  }
}
