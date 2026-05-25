library enums;

enum TipoUnidade {
  kg, g, l, ml, un, pacote, caixa, duzia, cabeca, maco, bandeja, frasco, pote, lata, outro,
}

enum TipoLista {
  avulsa,
  semanal,
  diaria,
}

enum StatusItem {
  pendente,
  comprado,
}

enum TemaApp {
  claro,
  escuro,
  sistema,
}

extension TipoUnidadeExt on TipoUnidade {
  String get displayName {
    switch (this) {
      case TipoUnidade.kg: return 'kg';
      case TipoUnidade.g: return 'g';
      case TipoUnidade.l: return 'L';
      case TipoUnidade.ml: return 'mL';
      case TipoUnidade.un: return 'un';
      case TipoUnidade.pacote: return 'pacote';
      case TipoUnidade.caixa: return 'caixa';
      case TipoUnidade.duzia: return 'dúzia';
      case TipoUnidade.cabeca: return 'cabeça';
      case TipoUnidade.maco: return 'maço';
      case TipoUnidade.bandeja: return 'bandeja';
      case TipoUnidade.frasco: return 'frasco';
      case TipoUnidade.pote: return 'pote';
      case TipoUnidade.lata: return 'lata';
      case TipoUnidade.outro: return 'outro';
    }
  }
  
  static TipoUnidade fromString(String value) {
    return TipoUnidade.values.firstWhere(
      (e) => e.displayName == value,
      orElse: () => TipoUnidade.outro,
    );
  }
}

extension TipoListaExt on TipoLista {
  String get displayName {
    switch (this) {
      case TipoLista.avulsa: return 'Avulsa';
      case TipoLista.semanal: return 'Semanal';
      case TipoLista.diaria: return 'Diária';
    }
  }
}

extension TemaAppExt on TemaApp {
  String get displayName {
    switch (this) {
      case TemaApp.claro: return 'Claro';
      case TemaApp.escuro: return 'Escuro';
      case TemaApp.sistema: return 'Sistema';
    }
  }
}