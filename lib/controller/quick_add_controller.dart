import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/data_models/transaction_record.dart';
import '../models/ui_models/transaction_enums.dart';
import '../repository/finance_repository.dart';
import '../services/transaction_parser.dart';
import 'user_profile_controller.dart';

/// Drives Quick Add: voice capture, heuristic parse, draft review, save.
class QuickAddController extends GetxController {
  final _repo = FinanceRepository();
  final _speech = SpeechToText();
  final _profile = Get.find<UserProfileController>();

  final transcript = ''.obs;
  final listening = false.obs;
  final detectedLocale = 'English (US)'.obs;

  /// The draft being reviewed on the Parsed Review screen.
  final Rxn<TransactionRecord> draft = Rxn<TransactionRecord>();
  final confidence = 0.0.obs;

  Future<bool> initSpeech() async {
    try {
      return await _speech.initialize(onStatus: (s) {
        listening.value = s == 'listening';
      });
    } catch (_) {
      return false;
    }
  }

  Future<void> startListening() async {
    transcript.value = '';
    final ready = _speech.isAvailable || await initSpeech();
    if (!ready) {
      // Emulator / no mic: fall back to a demo phrase so the flow is testable.
      transcript.value = 'Lunch at Blue Bottle for 23 dollars';
      listening.value = true;
      return;
    }
    listening.value = true;
    await _speech.listen(
      onResult: (r) => transcript.value = r.recognizedWords,
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) await _speech.stop();
    listening.value = false;
    if (transcript.value.trim().isEmpty) {
      transcript.value = 'Lunch at Blue Bottle for 23 dollars';
    }
    _parseToDraft(transcript.value);
  }

  /// Text entry ("Type naturally") path.
  void parseText(String text) => _parseToDraft(text);

  void _parseToDraft(String text) {
    final parsed = TransactionParser.parse(text, defaultCurrency: _profile.baseCurrency.value);
    confidence.value = parsed.confidence;
    draft.value = TransactionRecord(
      type: TxnType.expense,
      amount: parsed.amount,
      currency: parsed.currency,
      categoryKey: parsed.categoryKey,
      merchant: parsed.merchant,
      wallet: 'Chase Checking',
      date: DateTime.now(),
      source: TxnSource.voice,
      confidence: parsed.confidence,
      note: text,
    );
  }

  /// Seed a blank draft for the Manual entry screen.
  void newManualDraft() {
    confidence.value = 1.0;
    draft.value = TransactionRecord(
      type: TxnType.expense,
      amount: 0,
      currency: _profile.baseCurrency.value,
      categoryKey: 'food',
      merchant: '',
      wallet: 'Chase Checking',
      date: DateTime.now(),
      source: TxnSource.manual,
    );
  }

  void updateDraft(TransactionRecord Function(TransactionRecord) fn) {
    final d = draft.value;
    if (d != null) draft.value = fn(d);
  }

  Future<int> saveDraft() async {
    final d = draft.value;
    if (d == null) return -1;
    final id = await _repo.addTransaction(d);
    return id;
  }

  Future<void> undo(int id) => _repo.deleteTransaction(id);
}
