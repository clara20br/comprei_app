// lib/screens/home_screen.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lista_provider.dart';
import '../providers/categoria_provider.dart';
import '../providers/usuario_provider.dart';
import '../widgets/lista_card.dart';
import '../widgets/profile_popup_menu.dart';
import 'lista_detalhe_screen.dart';
import 'configuracoes_screen.dart';
import 'perfil_screen.dart';
import '../models/lista_compras.dart';
import '../core/themes/cores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _avatarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _registrarAcesso();
  }

  Future<void> _carregarDados() async {
    await context.read<ListaProvider>().carregarListas();
    await context.read<CategoriaProvider>().carregarCategorias();
    if (mounted) setState(() {});
  }
  
  Future<void> _registrarAcesso() async {
    await context.read<UsuarioProvider>().registrarAcesso();
  }

  Future<void> _criarNovaLista() async {
    final nomeController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nova Lista'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: TextField(
          controller: nomeController,
          decoration: InputDecoration(
            hintText: 'Nome da lista',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.shopping_cart, color: AppCores.verdePrincipal),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomeController.text.isNotEmpty) {
                final lista = ListaCompras(nome: nomeController.text);
                await context.read<ListaProvider>().criarLista(lista);
                
                if (mounted) {
                  await context.read<UsuarioProvider>().atualizarEstatisticas(
                    novasListas: 1,
                  );
                  
                  if (mounted) {
                    Navigator.pop(dialogContext);
                    _carregarDados();
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppCores.verdePrincipal,
            ),
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _mostrarMenuPerfil(BuildContext context) async {
    final RenderBox avatarBox = _avatarKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = avatarBox.localToGlobal(Offset.zero);
    final double avatarHeight = avatarBox.size.height;
    
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + avatarHeight + 8,
        position.dx + avatarBox.size.width,
        position.dy + avatarHeight + 8,
      ),
      items: [
        const PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          child: ProfilePopupMenu(),
        ),
      ],
      elevation: 0,
      color: Colors.transparent,
    );
  }

  void _abrirConfiguracoes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ConfiguracoesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaProvider = context.watch<ListaProvider>();
    final usuarioProvider = context.watch<UsuarioProvider>();
    final listas = listaProvider.listas;
    final usuario = usuarioProvider.usuarioAtual;

    return Scaffold(
      backgroundColor: AppCores.cinzaClaro,
      appBar: AppBar(
        title: const Text(
          'Minhas Listas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppCores.verdePrincipal,
        foregroundColor: AppCores.branco,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              key: _avatarKey,
              onTap: () => _mostrarMenuPerfil(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: usuario?.fotoPath != null && usuario!.fotoPath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _buildAvatarImage(usuario.fotoPath),
                      )
                    : Center(
                        child: Text(
                          _getIniciais(usuario?.nome ?? 'U'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _abrirConfiguracoes,
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: listas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppCores.verdePastel,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 50,
                      color: AppCores.verdePrincipal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Nenhuma lista ainda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppCores.cinzaEscuro,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque no botão + para criar sua primeira lista',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppCores.cinzaMedio,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listas.length,
                itemBuilder: (context, index) {
                  final lista = listas[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ListaCard(
                      lista: lista,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListaDetalheScreen(listaId: lista.id),
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirmado = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Excluir lista'),
                            content: Text('Deseja excluir "${lista.nome}"?'),
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
                                child: const Text(
                                  'Excluir',
                                  style: TextStyle(color: AppCores.vermelhoAlerta),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmado == true && mounted) {
                          await context.read<ListaProvider>().deletarLista(lista.id);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${lista.nome} excluída!'),
                                backgroundColor: AppCores.verdePrincipal,
                              ),
                            );
                            _carregarDados();
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _criarNovaLista,
        child: const Icon(Icons.add),
        backgroundColor: AppCores.verdePrincipal,
      ),
    );
  }

  Widget _buildAvatarImage(String? fotoPath) {
    if (fotoPath == null || fotoPath.isEmpty) {
      return const SizedBox.shrink();
    }
    
    if (fotoPath.startsWith('data:image')) {
      final base64String = fotoPath.split(',').last;
      return Image.memory(
        base64Decode(base64String),
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }
    
    return Image.file(
      File(fotoPath),
      width: 40,
      height: 40,
      fit: BoxFit.cover,
    );
  }

  String _getIniciais(String nome) {
    if (nome.isEmpty) return 'U';
    final partes = nome.trim().split(' ');
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
  }
}