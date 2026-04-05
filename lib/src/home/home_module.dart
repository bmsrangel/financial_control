import 'package:flutter_modular/flutter_modular.dart';

import '../core/core_module.dart';
import 'home_page.dart';
import 'services/ai_service.dart';
import 'services/google_sheets_service.dart';
import 'services/image_picker_service.dart';
import 'services/model_download_service.dart';
import 'stores/ai_store.dart';
import 'stores/google_sheets_store.dart';
import 'stores/model_download_store.dart';
import 'stores/ocr_store.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton(ModelDownloadService.new);
    i.addLazySingleton(AiService.new);
    i.addLazySingleton(ImagePickerService.new);
    i.addLazySingleton(GoogleSheetsService.new);

    i.addLazySingleton(ModelDownloadStore.new);
    i.addLazySingleton(AiStore.new);
    i.addLazySingleton(GoogleSheetsStore.new);
    i.addLazySingleton(OcrStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (_) => HomePage(
        title: 'Home',
        imagePickerService: Modular.get<ImagePickerService>(),
        aiStore: Modular.get<AiStore>(),
        downloadStore: Modular.get<ModelDownloadStore>(),
        ocrStore: Modular.get<OcrStore>(),
        googleSheetsStore: Modular.get<GoogleSheetsStore>(),
      ),
    );
  }
}
