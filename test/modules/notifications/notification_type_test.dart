import 'package:factory_erp_lite/modules/notifications/domain/models/notification_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('notificationIdFor is stable for type and source', () {
    final int id1 = notificationIdFor(
      NotificationType.recurringExpense,
      'expense-1',
    );
    final int id2 = notificationIdFor(
      NotificationType.recurringExpense,
      'expense-1',
    );
    final int id3 = notificationIdFor(
      NotificationType.maintenance,
      'expense-1',
    );

    expect(id1, id2);
    expect(id1, isNot(id3));
  });
}
