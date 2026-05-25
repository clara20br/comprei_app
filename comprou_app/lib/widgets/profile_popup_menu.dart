// lib/widgets/profile_popup_menu.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';
import '../screens/perfil_screen.dart';
import '../core/themes/cores.dart';

class ProfilePopupMenu extends StatelessWidget {
  const ProfilePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = context.watch<UsuarioProvider>();
    final usuario = usuarioProvider.usuarioAtual;

    if (usuario == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabeçalho com informações do usuário
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerfilScreen()),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppCores.verdePastel,
                    backgroundImage: _getImageProvider(usuario.fotoPath),
                    child: usuario.fotoPath == null || usuario.fotoPath!.isEmpty
                        ? Text(
                            _getIniciais(usuario.nome),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppCores.verdePrincipal,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Informações
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          usuario.email ?? 'Sem e-mail',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppCores.cinzaEscuro,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),
          
          const Divider(height: 1),
          
          // Estatísticas rápidas
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat(
                  icon: Icons.shopping_cart,
                  value: usuario.estatisticas.totalListasCriadas.toString(),
                  label: 'Listas',
                ),
                _buildQuickStat(
                  icon: Icons.check_circle,
                  value: usuario.estatisticas.totalItensComprados.toString(),
                  label: 'Itens',
                ),
                _buildQuickStat(
                  icon: Icons.attach_money,
                  value: 'R\$${usuario.estatisticas.totalGasto.toStringAsFixed(0)}',
                  label: 'Gasto',
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Menu items
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Meu Perfil',
            subtitle: 'Ver informações completas',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerfilScreen()),
              );
            },
          ),
          
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Configurações',
            subtitle: 'Ajustes do aplicativo',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/configuracoes');
            },
          ),
          
          _buildMenuItem(
            icon: Icons.history_outlined,
            title: 'Histórico',
            subtitle: 'Histórico de preços',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/historico');
            },
          ),
          
          const Divider(height: 1),
          
          // Botão Ver Mais
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PerfilScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ver mais',
                    style: TextStyle(
                      color: AppCores.verdePrincipal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: AppCores.verdePrincipal),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppCores.verdePrincipal),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppCores.cinzaEscuro,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppCores.verdePrincipal),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppCores.cinzaEscuro,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _getImageProvider(String? fotoPath) {
    if (fotoPath == null || fotoPath.isEmpty) return null;
    
    if (fotoPath.startsWith('data:image')) {
      final base64String = fotoPath.split(',').last;
      return MemoryImage(base64Decode(base64String));
    }
    
    return FileImage(File(fotoPath));
  }

  String _getIniciais(String nome) {
    final partes = nome.trim().split(' ');
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
  }
}