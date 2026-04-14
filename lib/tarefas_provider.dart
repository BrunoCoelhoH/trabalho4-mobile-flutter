import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modelo de Tarefa
class Tarefa {
  final String id;
  final String titulo;
  final bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });

  Tarefa copyWith({String? titulo, bool? concluida}) {
    return Tarefa(
      id: id,
      titulo: titulo ?? this.titulo,
      concluida: concluida ?? this.concluida,
    );
  }
}

// Notifier atualizado para Riverpod 3.x
class TarefasNotifier extends Notifier<List<Tarefa>> {
  @override
  List<Tarefa> build() => [];

  void adicionarTarefa(String titulo) {
    final novaTarefa = Tarefa(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
    );
    state = [...state, novaTarefa];
  }

  void alternarConclusao(String id) {
    state = state.map((tarefa) {
      if (tarefa.id == id) {
        return tarefa.copyWith(concluida: !tarefa.concluida);
      }
      return tarefa;
    }).toList();
  }

  void removerTarefa(String id) {
    state = state.where((tarefa) => tarefa.id != id).toList();
  }
}

// Provider global
final tarefasProvider = NotifierProvider<TarefasNotifier, List<Tarefa>>(
  TarefasNotifier.new,
);
