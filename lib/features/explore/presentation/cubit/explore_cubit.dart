import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/ai_repository.dart';
import '../../data/repositories/animal_repository.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final AIRepository _aiRepository = AIRepository();
  final ImagePicker _picker = ImagePicker();

  ExploreCubit() : super(ExploreInitial());

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        await analyzeImage(imageFile);
      }
    } catch (e) {
      // 🌟 معالجة رفض المستخدم لإعطاء صلاحية الكاميرا أو المعرض
      if (e.toString().contains('camera_access_denied') ||
          e.toString().contains('photo_access_denied')) {
        emit(
          const ExploreError(
            'ليس لدينا صلاحية للوصول للكاميرا/المعرض. يرجى تفعيلها من إعدادات الهاتف.',
          ),
        );
      } else {
        emit(ExploreError('فشل في فتح الكاميرا: $e'));
      }
    }
  }

Future<void> analyzeImage(File imageFile) async {
    try {
      emit(ExploreLoading(message: 'جاري التعرف على الحيوان...', image: imageFile));

      // 1. الذكاء الاصطناعي بيتعرف على اسم الحيوان بس
      final animalName = await _aiRepository.analyzeImage(imageFile);
      if (isClosed) return;

      emit(ExploreLoading(message: 'جاري البحث في قاعدة البيانات...', image: imageFile));

      // 2. بندور في الداتا بيز بتاعتنا (99 حيوان)
      final localAnimal = AnimalRepository.smartMatch(animalName);
      if (isClosed) return;

      // 3. لو لقيناه، نعرضه. لو ملقيناهوش، نطلع إيرور.
      if (localAnimal != null) {
        emit(ExploreSuccess(animal: localAnimal, image: imageFile, isFromAI: false));
      } else {
        // 🌟 الحيوان مش موجود في الداتا بيز بتاعتنا
        emit(const ExploreError("عذراً، هذا الحيوان غير موجود في قاعدة بيانات الحديقة حالياً!"));
      }
    } catch (e) {
      if (isClosed) return; 

      String errorMessage = 'حدث خطأ غير متوقع. حاول مرة أخرى.';
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('timeout') || errorString.contains('استغرق وقتا')) {
        errorMessage = '⏳ الإنترنت ضعيف والسيرفر استغرق وقتاً طويلاً. تأكد من الشبكة وحاول تاني.';
      } else if (errorString.contains('socketexception') || errorString.contains('failed host lookup') || errorString.contains('connection abort')) {
        errorMessage = '🌐 لا يوجد اتصال بالإنترنت. تأكد من تشغيل الواي فاي أو باقة الموبايل.';
      } else if (errorString.contains('429') || errorString.contains('402') || errorString.contains('الضغط عالي')) {
        errorMessage = '🚦 هناك ضغط كبير على الخادم حالياً. يرجى المحاولة بعد دقيقة.';
      } else {
        errorMessage = e.toString().replaceAll('Exception:', '').trim();
      }

      emit(ExploreError(errorMessage));
    }
  }

  void reset() {
    emit(ExploreInitial());
  }
}
