class AppNotification {
  final int? id;
  final String type; // budget | bill | insight | milestone | travel | unusual
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    this.id,
    this.type = 'insight',
    required this.title,
    this.body = '',
    required this.timestamp,
    this.isRead = false,
  });

  bool get isAlert => type == 'budget' || type == 'bill' || type == 'unusual';

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'is_read': isRead ? 1 : 0,
      };

  factory AppNotification.fromMap(Map<String, dynamic> m) => AppNotification(
        id: m['id'] as int?,
        type: m['type'] as String? ?? 'insight',
        title: m['title'] as String? ?? '',
        body: m['body'] as String? ?? '',
        timestamp: DateTime.tryParse(m['timestamp'] as String? ?? '') ?? DateTime.now(),
        isRead: (m['is_read'] as int? ?? 0) == 1,
      );
}
