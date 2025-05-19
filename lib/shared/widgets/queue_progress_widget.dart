import 'package:bridgecare/shared/services/queue_service.dart';
import 'package:flutter/material.dart';

class QueueProgressWidget extends StatelessWidget {
  final QueueService queueService;
  final VoidCallback onHide;
  final VoidCallback onTap;

  const QueueProgressWidget({
    super.key,
    required this.queueService,
    required this.onHide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16.0,
      right: 16.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: queueService.queueProgress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  Icon(Icons.cloud_upload_outlined, color: Colors.blueGrey),
                ],
              ),
              const SizedBox(width: 8.0),
              Text(
                '${(queueService.queueProgress * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: onHide,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
