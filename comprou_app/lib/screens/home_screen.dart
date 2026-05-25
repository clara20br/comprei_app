import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lista_provider.dart';
import '../providers/categoria_provider.dart';
import '../widgets/lista_card.dart';
import 'lista_detalhe_screen.dart';
import 'configuracoes_screen.dart';
import '../models/lista_compras.dart';
import '../core/themes/cores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await context.read<ListaProvider>().carregarListas();
    await context.read<CategoriaProvider>().carregarCategorias();
    if (mounted) setState(() {});
  }

  Future<void> _criarNovaLista() async {
    final nomeController = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomeController.text.isNotEmpty && mounted) {
                final lista = ListaCompras(nome: nomeController.text);
                await context.read<ListaProvider>().criarLista(lista);
                if (mounted) {
                  Navigator.pop(context);
                  _carregarDados();
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

  void _abrirConfiguracoes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ConfiguracoesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaProvider = context.watch<ListaProvider>();
    final listas = listaProvider.listas;

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
                    child: Icon(
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
          : ListView.builder(
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
                        builder: (context) => AlertDialog(
                          title: const Text('Excluir lista'),
                          content: Text('Deseja excluir "${lista.nome}"?'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _criarNovaLista,
        child: const Icon(Icons.add),
        backgroundColor: AppCores.verdePrincipal,
      ),
    );
  }
}