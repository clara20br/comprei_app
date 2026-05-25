import 'package:flutter/material.dart';
import '../models/lista_compras.dart';
import '../core/themes/cores.dart';
import '../core/constants/constants.dart';

class ListaCard extends StatelessWidget {
  final ListaCompras lista;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ListaCard({
    super.key,
    required this.lista,
    required this.onTap,
    this.onDelete,
  });

  String _getIconPorTipo() {
    switch (lista.tipo.name) {
      case 'semanal':
        return '📅';
      case 'diaria':
        return '☀️';
      default:
        return '🛒';
    }
  }

  String _getLabelPorTipo() {
    switch (lista.tipo.name) {
      case 'semanal':
        return 'Semanal';
      case 'diaria':
        return 'Diária';
      default:
        return 'Avulsa';
    }
  }

  Color _getCorPorTipo() {
    switch (lista.tipo.name) {
      case 'semanal':
        return AppCores.amareloDestaque;
      case 'diaria':
        return AppCores.azulInfo;
      default:
        return AppCores.verdeClaro;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'lista_${lista.id}',
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        shadowColor: AppCores.verdePrincipal.withOpacity(0.3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppCores.verdePastel,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Ícone com fundo
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: _getCorPorTipo().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        _getIconPorTipo(),
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Informações
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lista.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppCores.cinzaEscuro,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getCorPorTipo().withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 10,
                                    color: _getCorPorTipo(),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getLabelPorTipo(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: _getCorPorTipo(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: AppCores.cinzaMedio,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatarData(lista.criadoEm),
                              style: TextStyle(
                                fontSize: 11,
                                color: AppCores.cinzaMedio,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Botão de deletar
                  if (onDelete != null)
                    Container(
                      decoration: BoxDecoration(
                        color: AppCores.vermelhoAlerta.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete_outline, size: 22, color: AppCores.vermelhoAlerta),
                        onPressed: onDelete,
                      ),
                    ),
                  
                  // Seta
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppCores.verdePrincipal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.chevron_right, size: 20, color: AppCores.verdePrincipal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final diff = DateTime.now().difference(data);
    if (diff.inDays == 0) return 'Hoje';
    if (diff.inDays == 1) return 'Ontem';
    if (diff.inDays < 7) return 'Há ${diff.inDays} dias';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}