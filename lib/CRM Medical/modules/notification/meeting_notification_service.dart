import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibration/vibration.dart';
import 'notification_service.dart';

class MeetingNotificationService {
  static final Set<String> _alreadyNotified = {};

  static Future<void> checkMeetings(QuerySnapshot snapshot) async {
    final now = DateTime.now();

    for (final doc in snapshot.docs) {
      final Timestamp ts = doc['date'];
      final DateTime meetingDate = ts.toDate();
      final int diffSeconds = meetingDate.difference(now).inSeconds;

      // Condition : moins d'1 minute
      if (diffSeconds > 0 &&
          diffSeconds <= 60 &&
          !_alreadyNotified.contains(doc.id)) {

        _alreadyNotified.add(doc.id);

        // Notification+
        await NotificationService.showMeetingNotification(
          'Appointment Reminder',
          'Your appointment with ${doc['doctor']} starts in less than 1 minute',
        );

        // Vibration
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 1000);
        }
      }
    }
  }
}
