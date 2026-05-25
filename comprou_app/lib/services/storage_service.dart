// lib/services/storage_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static Future<String?> salvarFotoPerfil(File imagem) async {
    try {
      final diretorio = await getApplicationDocumentsDirectory();
      final nomeArquivo = 'perfil_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final caminho = '${diretorio.path}/$nomeArquivo';
      
      await imagem.copy(caminho);
      return caminho;
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> deletarFotoPerfil(String caminho) async {
    try {
      final arquivo = File(caminho);
      if (await arquivo.exists()) {
        await arquivo.delete();
      }
    } catch (e) {
      // Ignorar erros
    }
  }
  
  static Future<File?> selecionarFoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}