import 'package:admin_taag/services/push_notification_services.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

final _titleController = TextEditingController();
final _bodyController = TextEditingController();
final _notificationService = FirebaseNotification();

class _NotificationViewState extends State<NotificationView> {
  // void dispose() {
  //   _titleController.dispose();
  //   _bodyController.dispose();
  //   super.dispose();
  // }

  Future<void> _sendNotification() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Title and body cannot be empty',
          style: TextStyle(fontFamily: "Cairo"),
        )),
      );
      return;
    }

    try {
      await _notificationService.sendNotificationToAll(title, body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Notification sent successfully!',
          style: TextStyle(fontFamily: "Cairo"),
        )),
      );
      _titleController.clear();
      _bodyController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send notification: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Notification',
          style: TextStyle(fontFamily: "Cairo"),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Notification Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      hintText: 'Notification Body',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 8, // Allow multiline input for body
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _sendNotification,
                    child: const Text(
                      'Send Notification',
                      style: TextStyle(fontFamily: "Cairo"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DescriptionTextField extends StatelessWidget {
  const DescriptionTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: 10,
      child: TextField(
        onChanged: (value) {},
        maxLines: 6,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        controller: TextEditingController(),
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          border: InputBorder.none,
          filled: false,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: 'Text Here',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? const Color(0XFF1E1E1E),
          ),
          const BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black,
          ),
        ],
      ),
      child: child,
    );
  }
}
