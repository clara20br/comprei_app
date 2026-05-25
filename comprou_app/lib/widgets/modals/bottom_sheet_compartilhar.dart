import 'package:flutter/material.dart';

class BottomSheetCompartilhar extends StatelessWidget {
  final String listaNome;
  final String listaId;

  const BottomSheetCompartilhar({
    super.key,
    required this.listaNome,
    required this.listaId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compartilhar Lista',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildOption(
            context,
            icon: Icons.copy,
            title: 'Copiar lista',
            subtitle: 'Copia o texto da lista',
            onTap: () => _copiarLista(context),
          ),
          _buildOption(
            context,
            icon: Icons.share,
            title: 'Compartilhar WhatsApp',
            subtitle: 'Enviar via WhatsApp',
            onTap: () => _compartilharWhatsApp(context),
          ),
          _buildOption(
            context,
            icon: Icons.picture_as_pdf,
            title: 'Gerar PDF',
            subtitle: 'Criar um arquivo PDF',
            onTap: () => _gerarPDF(context),
          ),
          _buildOption(
            context,
            icon: Icons.save_alt,
            title: 'Salvar arquivo',
            subtitle: 'Salvar como JSON',
            onTap: () => _salvarArquivo(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _copiarLista(BuildContext context) {
    // Implementar cópia da lista
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista copiada!')),
    );
  }

  void _compartilharWhatsApp(BuildContext context) {
    // Implementar compartilhamento WhatsApp
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compartilhar via WhatsApp (em desenvolvimento)')),
    );
  }

  void _gerarPDF(BuildContext context) {
    // Implementar geração de PDF
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gerar PDF (em desenvolvimento)')),
    );
  }

  void _salvarArquivo(BuildContext context) {
    // Implementar salvar arquivo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salvar arquivo (em desenvolvimento)')),
    );
  }
}