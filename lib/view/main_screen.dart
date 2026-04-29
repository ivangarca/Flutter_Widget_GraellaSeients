import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/main_viewmodel.dart';
import 'widgets/graella_seients_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController(); //la barra del scroll

  //cuando se cierre la pantalla cierra esas dos cosas
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  //context.watch significa que la pantalla se queda escuchando atentamente al ViewModel (vm).
  // Cada vez que el ViewModel grita "¡notifyListeners!", esta pantalla vuelve a ejecutar todo el build para redibujarse con los datos nuevos.
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewModel>();

    return
      Scaffold( //pantalla en blanco
      appBar: AppBar( //cabecera azul
        title: const Text("Reserva de Seients (Grup 05)"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector( //Envuelve TODA la pantalla. Si el usuario hace clic en cualquier zona gris del fondo (fuera de los asientos o los botones), detecta el toque (onTap). Si hay asientos verdes, llama al cerebro para limpiarlos (vm.netejarSeleccio()). El HitTestBehavior.translucent asegura que detecte el clic incluso en espacios vacíos.
        behavior: HitTestBehavior.translucent, // por si no hay nada en el fondo se pueda clicar igual
        onTap: () {
          if (vm.estatGraella.seleccionats.isNotEmpty) { // si no esta vacia la lista de selccionados la vacia llamado al neteja
            vm.netejarSeleccio();
          }
        },
        child: Scrollbar(//widget que se encarga de dibujar la barra de desplazamiento visua
          controller: _scrollController,  //Es el "cable" que conecta esta barra dibujada con el contenido real que se mueve. comparten mismo cable para funcionar juntos.
          thumbVisibility: true, // Obliga a mostrar la barra (el "polze")
          trackVisibility: true, // Obliga a mostrar el carril gris del fons permanentment
          interactive: true,     // Permite que se pueda arrastrar
          thickness: 14,         // Tamaño
          radius: const Radius.circular(8),

          child: SingleChildScrollView( //widget que Si el contenido no cabe en el monitor, permite hacer scroll para abajo.
            controller: _scrollController, //El otro extremo del "cable". Al poner aquí el mismo _scrollController que en el Scrollbar, quedan enlazados.
            physics: const AlwaysScrollableScrollPhysics(),

            child: Center( // lo que hay dentro va en el centro de la pantalla
              child: Padding( //añade padding de 16
                padding: const EdgeInsets.all(16.0),
                child: Column( //Apila los elementos de arriba a abajo (Título -> Asientos -> Botones).
                  mainAxisAlignment: MainAxisAlignment.center, //centro vertical
                  children: [
                    const Text( //frase y caracteristicas
                      "Tria els teus seients:",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20), //Es un widget invisible que usamos como un "espaciador" para dejar 20 píxeles de hueco entre el título y la cuadrícula.

                    SingleChildScrollView( //hacer scroll de izquierda a derecha.
                      scrollDirection: Axis.horizontal,
                      child: GraellaSeientsWidget(
                        estat: vm.estatGraella,
                        totalSeients: vm.totalSeients,
                        columnes: vm.columnes,
                        onSelected: (novaLlista) => vm.actualitzarSeleccio(novaLlista),
                        onMaxReached: () => vm.avisarLimitAssolit(),
                        onClear: () => vm.netejarSeleccio(),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row( //izquierda a derecha los dos botones, caracteristicas de los botones
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: vm.estatGraella.seleccionats.isEmpty
                              ? null
                              : () => vm.confirmarSeleccio(),
                          icon: const Icon(Icons.check_circle),
                          label: const Text(
                            "Confirmar Reserva",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),

                        FloatingActionButton.extended(
                          onPressed: () => _mostrarFinestraConfiguracio(context, vm),
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          icon: const Icon(Icons.settings),
                          label: const Text("Mida"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Funció que mostra la "Mini Finestra" per canviar files i columnes
  void _mostrarFinestraConfiguracio(BuildContext context, MainViewModel vm) {
    final filesController = TextEditingController(text: vm.files.toString());
    final columnesController = TextEditingController(text: vm.columnes.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Configurar Mida de la Sala"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: filesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de Files",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.table_rows),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: columnesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de Columnes",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.view_column),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "⚠️ Avís: En canviar la mida s'esborraran les reserves actuals de la pantalla.",
                style: TextStyle(color: Colors.red, fontSize: 12),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel·lar"),
            ),
            ElevatedButton(
              onPressed: () {
                final novesFiles = int.tryParse(filesController.text) ?? 5;
                final novesColumnes = int.tryParse(columnesController.text) ?? 8;
                vm.actualitzarDimensions(novesFiles, novesColumnes);
                Navigator.pop(context);
              },
              child: const Text("Aplicar"),
            ),
          ],
        );
      },
    );
  }
}