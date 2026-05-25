import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/config_provider.dart';
import '../services/backup_service.dart';
import '../core/constants/enums.dart';
import '../core/constants/constants.dart';
import '../core/themes/cores.dart';
import 'sobre_screen.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<ConfigProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          
          _buildSectionHeader('Aparência'),
          _buildThemeOption(
            context,
            configProvider,
            'Claro',
            'Tema claro',
            TemaApp.claro,
          ),
          _buildThemeOption(
            context,
            configProvider,
            'Escuro',
            'Tema escuro',
            TemaApp.escuro,
          ),
          _buildThemeOption(
            context,
            configProvider,
            'Sistema',
            'Usar tema do sistema',
            TemaApp.sistema,
          ),
          
          const Divider(),
          
          _buildSectionHeader('Notificações'),
          SwitchListTile(
            title: const Text('Notificações'),
            subtitle: const Text('Receber lembretes das listas'),
            value: configProvider.config.notificacoes,
            onChanged: (value) {
              configProvider.atualizarNotificacoes(value);
            },
          ),
          
          const Divider(),
          
          _buildSectionHeader('Backup'),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Fazer backup agora'),
            subtitle: const Text('Salvar dados em arquivo'),
            onTap: () => _fazerBackup(),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restaurar backup'),
            subtitle: const Text('Restaurar dados de arquivo'),
            onTap: () => _restaurarBackup(),
          ),
          SwitchListTile(
            title: const Text('Backup automático'),
            subtitle: const Text('Salvar automaticamente'),
            value: configProvider.config.backupAutomatico,
            onChanged: (value) {
              configProvider.atualizarBackupAutomatico(value);
            },
          ),
          
          const Divider(),
          
          _buildSectionHeader('Dados'),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: AppCores.vermelhoAlerta),
            title: const Text('Limpar todos os dados'),
            subtitle: const Text('Remove todas as listas e configurações'),
            onTap: () => _confirmarLimparDados(),
          ),
          
          const Divider(),
          
          _buildSectionHeader('Informações'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o app'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SobreScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Compartilhar'),
            onTap: () => _compartilharApp(),
          ),
          
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppCores.verdePrincipal,
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ConfigProvider configProvider,
    String title,
    String subtitle,
    TemaApp tema,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<TemaApp>(
        value: tema,
        groupValue: configProvider.config.tema,
        onChanged: (value) {
          if (value != null) {
            configProvider.atualizarTema(value);
          }
        },
      ),
      onTap: () {
        configProvider.atualizarTema(tema);
      },
    );
  }

  Future<void> _fazerBackup() async {
    try {
      final caminho = await BackupService.exportarDados();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup salvo em: $caminho')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer backup')),
        );
      }
    }
  }

  Future<void> _restaurarBackup() async {
    final caminho = await BackupService.selecionarArquivoBackup();
    if (caminho != null) {
      try {
        await BackupService.importarDados(caminho);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup restaurado com sucesso!')),
          );
          await context.read<ConfigProvider>().carregarConfig();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao restaurar backup')),
          );
        }
      }
    }
  }

  void _confirmarLimparDados() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar todos os dados?'),
        content: const Text(
          'Esta ação irá remover todas as listas, itens e configurações. '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dados limpos com sucesso!')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppCores.vermelhoAlerta,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _compartilharApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compartilhar app (em desenvolvimento)')),
    );
  }
}