import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tarefas_provider.dart';

// Widget do campo de entrada de nova tarefa
class CampoNovaTarefa extends ConsumerStatefulWidget {
  const CampoNovaTarefa({super.key});

  @override
  ConsumerState<CampoNovaTarefa> createState() => _CampoNovaTarefaState();
}

class _CampoNovaTarefaState extends ConsumerState<CampoNovaTarefa> {
  final _controller = TextEditingController();

  void _adicionarTarefa() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    ref.read(tarefasProvider.notifier).adicionarTarefa(texto);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _adicionarTarefa(),
              decoration: InputDecoration(
                hintText: 'Nova tarefa...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _adicionarTarefa,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Adicionar', style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

// Widget de item individual da lista
class ItemTarefa extends ConsumerWidget {
  final Tarefa tarefa;

  const ItemTarefa({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: GestureDetector(
            onTap: () => ref.read(tarefasProvider.notifier).alternarConclusao(tarefa.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tarefa.concluida ? const Color(0xFF6C63FF) : Colors.transparent,
                border: Border.all(
                  color: tarefa.concluida ? const Color(0xFF6C63FF) : Colors.grey,
                  width: 2,
                ),
              ),
              child: tarefa.concluida
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          title: Text(
            tarefa.titulo,
            style: TextStyle(
              fontSize: 16,
              decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
              color: tarefa.concluida ? Colors.grey : Colors.black87,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => ref.read(tarefasProvider.notifier).removerTarefa(tarefa.id),
          ),
        ),
      ),
    );
  }
}

// Widget da lista de tarefas
class ListaTarefas extends ConsumerWidget {
  const ListaTarefas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarefas = ref.watch(tarefasProvider);

    if (tarefas.isEmpty) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'Nenhuma tarefa ainda.',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          return ItemTarefa(tarefa: tarefas[index]);
        },
      ),
    );
  }
}
