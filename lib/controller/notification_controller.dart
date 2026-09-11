import 'package:get/get.dart';
import '../models/data_models/app_notification.dart';
import '../repository/finance_repository.dart';

class NotificationController extends GetxController {
  final _repo = FinanceRepository();
  final items = <AppNotification>[].obs;
  final filter = 'all'.obs; // all | alerts | updates

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    items.value = await _repo.notifications();
  }

  List<AppNotification> get visible {
    switch (filter.value) {
      case 'alerts':
        return items.where((n) => n.isAlert).toList();
      case 'updates':
        return items.where((n) => !n.isAlert).toList();
      default:
        return items;
    }
  }

  int get alertCount => items.where((n) => n.isAlert).length;
  int get updateCount => items.where((n) => !n.isAlert).length;
}
