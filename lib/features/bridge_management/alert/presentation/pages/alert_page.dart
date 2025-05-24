import 'package:flutter/material.dart';
import 'package:bridgecare/features/bridge_management/alert/models/alerta.dart';
import 'package:bridgecare/features/bridge_management/alert/services/alert_service.dart';

class AlertScreen extends StatefulWidget {
  final int puenteId;

  const AlertScreen({super.key, required this.puenteId});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final AlertService _alertService = AlertService();
  late Future<List<Alerta>> _alertas;

  @override
  void initState() {
    super.initState();
    _alertas = _alertService.getAlertasPorPuente(widget.puenteId);
  }
  Color getAlertColor(String tipo) {
    switch (tipo.toUpperCase()) {
      case 'CRITICA':
        return Colors.red;
      case 'PRECAUCION':
        return Colors.orange;
      case 'NORMAL':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff281537), Color(0xff1780cc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Encabezado con botón de regreso
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xccffffff),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Alertas del puente',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Contenido de alertas
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xccffffff),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: FutureBuilder<List<Alerta>>(
                      future: _alertas,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No hay alertas disponibles.'));
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final alerta = snapshot.data![index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      alerta.tipo,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: getAlertColor(alerta.tipo), // ← aquí se aplica el color dinámico
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      alerta.mensaje,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}