// lib/screens/perfil_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/usuario_provider.dart';
import '../services/storage_service.dart';
import '../widgets/avatar_widget.dart';
import '../core/themes/cores.dart';
import 'editar_perfil_screen.dart';

// Importar os modelos necessários
import '../models/usuario.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = context.watch<UsuarioProvider>();
    final usuario = usuarioProvider.usuarioAtual;

    if (usuario == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editarPerfil(context),
            tooltip: 'Editar perfil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Avatar
            AvatarWidget(
              fotoPath: usuario.fotoPath,
              nome: usuario.nome,
              radius: 60,
              editavel: true,
              onTap: () => _editarFoto(context),
            ),
            
            const SizedBox(height: 16),
            
            // Nome
            Text(
              usuario.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Email (se existir)
            if (usuario.email != null) ...[
              Text(
                usuario.email!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppCores.cinzaEscuro,
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            const SizedBox(height: 32),
            
            // Estatísticas
            _buildEstatisticas(usuario.estatisticas),
            
            const SizedBox(height: 32),
            
            // Menu
            _buildMenuItem(
              icon: Icons.settings,
              title: 'Preferências',
              subtitle: 'Configurações do aplicativo',
              onTap: () => _irPreferencias(context),
            ),
            
            _buildMenuItem(
              icon: Icons.history,
              title: 'Histórico de Preços',
              subtitle: 'Ver histórico de compras',
              onTap: () => _irHistorico(context),
            ),
            
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Sobre o App',
              subtitle: 'Versão 1.0.0',
              onTap: () => _irSobre(context),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEstatisticas(EstatisticasUsuario estatisticas) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Estatísticas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  icon: Icons.shopping_cart,
                  valor: estatisticas.totalListasCriadas.toString(),
                  label: 'Listas',
                ),
                _buildStatCard(
                  icon: Icons.check_circle,
                  valor: estatisticas.totalItensComprados.toString(),
                  label: 'Itens',
                ),
                _buildStatCard(
                  icon: Icons.attach_money,
                  valor: 'R\$${estatisticas.totalGasto.toStringAsFixed(0)}',
                  label: 'Gasto',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String valor,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppCores.verdePrincipal),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppCores.verdePrincipal),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Future<void> _editarPerfil(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const EditarPerfilScreen()),
    );
    
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: AppCores.verdePrincipal,
        ),
      );
    }
  }

  Future<void> _editarFoto(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Foto de Perfil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppCores.verdePastel,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.camera_alt, color: AppCores.verdePrincipal),
              ),
              title: const Text('Tirar foto', style: TextStyle(fontSize: 16)),
              subtitle: const Text('Usar a câmera do dispositivo'),
              onTap: () async {
                Navigator.pop(sheetContext);
                
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (loadingContext) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                final picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 500,
                  maxHeight: 500,
                  imageQuality: 85,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  
                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    final base64String = base64Encode(bytes);
                    await context.read<UsuarioProvider>().atualizarPerfilFotoBase64(
                      base64String: base64String,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Foto atualizada com sucesso!'),
                          backgroundColor: AppCores.verdePrincipal,
                        ),
                      );
                    }
                  }
                }
              },
            ),
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppCores.verdePastel,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.photo_library, color: AppCores.verdePrincipal),
              ),
              title: const Text('Escolher da galeria', style: TextStyle(fontSize: 16)),
              subtitle: const Text('Selecionar uma foto existente'),
              onTap: () async {
                Navigator.pop(sheetContext);
                
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (loadingContext) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                final picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 500,
                  maxHeight: 500,
                  imageQuality: 85,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  
                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    final base64String = base64Encode(bytes);
                    await context.read<UsuarioProvider>().atualizarPerfilFotoBase64(
                      base64String: base64String,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Foto atualizada com sucesso!'),
                          backgroundColor: AppCores.verdePrincipal,
                        ),
                      );
                    }
                  }
                }
              },
            ),
            
            if (context.read<UsuarioProvider>().usuarioAtual?.fotoPath != null)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Remover foto', style: TextStyle(fontSize: 16, color: Colors.red)),
                subtitle: const Text('Remover a foto de perfil atual'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  
                  final confirmado = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Remover foto'),
                      content: const Text('Tem certeza que deseja remover sua foto de perfil?'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Remover'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmado == true && context.mounted) {
                    await context.read<UsuarioProvider>().removerFoto();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Foto removida com sucesso'),
                          backgroundColor: AppCores.verdePrincipal,
                        ),
                      );
                    }
                  }
                },
              ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _irPreferencias(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferências em desenvolvimento')),
    );
  }

  void _irHistorico(BuildContext context) {
    Navigator.pushNamed(context, '/historico');
  }

  void _irSobre(BuildContext context) {
    Navigator.pushNamed(context, '/sobre');
  }
}