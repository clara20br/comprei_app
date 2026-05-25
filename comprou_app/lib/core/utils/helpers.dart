library helpers;

import 'package:intl/intl.dart';

class Helpers {
  static String formatarMoeda(double? valor) {
    if (valor == null) return 'R\$ --';
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(valor);
  }
  
  static String formatarData(DateTime data) {
    final format = DateFormat('dd/MM/yyyy HH:mm');
    return format.format(data);
  }
  
  static String formatarDataCompacta(DateTime data) {
    final format = DateFormat('dd/MM/yy');
    return format.format(data);
  }
  
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
  
  static String gerarId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  static String capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1).toLowerCase();
  }
  
  static double? parseDouble(String value) {
    if (value.isEmpty) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }
}