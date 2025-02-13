import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class ServerStatusPage extends StatelessWidget {
  const ServerStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketService.serverStatus}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                socketService.socket?.emit('emitir-mensaje', {
                  'nombre': 'Flutter',
                  'mensaje': 'Hola desde Flutter',
                });
              },
              child: const Text('Check Server Status'),
            ),
          ],
        ),
      ),
    );
  }
}
