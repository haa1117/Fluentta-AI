import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';

class ProgressSyncRepository {
  ProgressSyncRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _progressRef(String uid) =>
      _firestore.collection('users').doc(uid).collection('lessonProgress');

  Future<Map<String, LessonProgressModel>> fetchAll(String uid) async {
    final snapshot = await _progressRef(uid).get();
    final result = <String, LessonProgressModel>{};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      data['lessonId'] ??= doc.id;
      result[doc.id] = LessonProgressModel.fromFirestore(data);
    }
    return result;
  }

  Future<void> upsert(String uid, LessonProgressModel progress) async {
    await _progressRef(uid).doc(progress.lessonId).set(
      {
        ...progress.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> upsertBatch(
    String uid,
    Map<String, LessonProgressModel> progressMap,
  ) async {
    if (progressMap.isEmpty) return;
    final batch = _firestore.batch();
    for (final progress in progressMap.values) {
      batch.set(
        _progressRef(uid).doc(progress.lessonId),
        {
          ...progress.toFirestore(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }
}
