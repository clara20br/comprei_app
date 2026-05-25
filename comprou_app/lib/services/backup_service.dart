import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/lista_compras.dart';
import '../models/categoria.dart';
import '../models/item.dart';
import '../models/historico_preco.dart';
import 'database_service.dart';

class BackupService {
  static Future<String> exportarDados() async {
    final backup = {
      'versao': 1,
      'data': DateTime.now().toIso8601String(),
      'listas': DatabaseService.listas.map((l) => l.toMap()).toList(),
      'categorias': DatabaseService.categorias.map((c) => c.toMap()).toList(),
      'itens': DatabaseService.itens.map((i) => i.toMap()).toList(),
      'historico': DatabaseService.historico.map((h) => h.toMap()).toList(),
    };
    
    final jsonString = jsonEncode(backup);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(filePath);
    await file.writeAsString(jsonString);
    
    return filePath;
  }
  
  static Future<void> importarDados(String filePath) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    final backup = jsonDecode(jsonString);
    
    for (var lista in backup['listas']) {
      await DatabaseService.salvarLista(ListaCompras.fromMap(lista));
    }
    
    for (var categoria in backup['categorias']) {
      await DatabaseService.salvarCategoria(Categoria.fromMap(categoria));
    }
    
    for (var item in backup['itens']) {
      await DatabaseService.salvarItem(Item.fromMap(item));
    }
    
    for (var historico in backup['historico']) {
      await DatabaseService.salvarHistorico(HistoricoPreco.fromMap(historico));
    }
  }
  
  static Future<String?> selecionarArquivoBackup() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    
    if (result != null) {
      return result.files.single.path;
    }
    return null;
  }
}