import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/vocabulary_word_entry.dart';
import 'package:fluentta_ai/data/repositories/saved_words_repository.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';

class SavedWordsViewModel extends ChangeNotifier {
  SavedWordsViewModel({
    required SavedWordsRepository savedWordsRepository,
    required TextToSpeechService textToSpeechService,
  })  : _savedWordsRepository = savedWordsRepository,
        _textToSpeechService = textToSpeechService {
    _savedWordsRepository.addListener(_onSavedWordsChanged);
    load();
  }

  final SavedWordsRepository _savedWordsRepository;
  final TextToSpeechService _textToSpeechService;

  List<VocabularyWordEntry> _words = [];
  bool _isLoading = true;
  String? _listeningWordId;

  List<VocabularyWordEntry> get words => _words;
  bool get isLoading => _isLoading;
  bool get isEmpty => _words.isEmpty;

  bool isListening(String wordId) => _listeningWordId == wordId;

  void _onSavedWordsChanged() {
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _words = await _savedWordsRepository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeWord(String wordId) async {
    await _savedWordsRepository.remove(wordId);
  }

  Future<void> listenWord(VocabularyWordEntry entry) async {
    if (_listeningWordId == entry.id) {
      await _textToSpeechService.stop();
      _listeningWordId = null;
      notifyListeners();
      return;
    }

    _listeningWordId = entry.id;
    notifyListeners();

    await _textToSpeechService.speak(
      entry.word,
      onComplete: () {
        _listeningWordId = null;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _savedWordsRepository.removeListener(_onSavedWordsChanged);
    _textToSpeechService.stop();
    super.dispose();
  }
}
