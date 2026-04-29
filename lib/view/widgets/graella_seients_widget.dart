import 'package:flutter/material.dart';
import '../../model/graella_seients_state.dart';

//Es visual y muesra lo que yo diga
class GraellaSeientsWidget extends StatelessWidget {
  final GraellaSeientsState estat;
  final int totalSeients;
  final int columnes;
  final double borderRadius;
  final double midaSeient;

  //onSelected, onMaxReached, onClear): Son los "cables" que conectan este widget con el exterior. Como el widget no puede cambiar los datos por sí mismo, cuando el usuario hace clic, el widget usa estos cables para mandarle una señal eléctrica al ViewModel.
  final Function(List<int>) onSelected;
  final VoidCallback onMaxReached;
  final VoidCallback onClear;

  const GraellaSeientsWidget({
    super.key,
    required this.estat,
    required this.totalSeients,
    this.columnes = 8,
    this.borderRadius = 8.0,
    this.midaSeient = 50.0,
    required this.onSelected,
    required this.onMaxReached,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        //cabecera
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Seleccionats: ${estat.seleccionats.length} / ${estat.maxSeleccionables}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.clear_all, color: Colors.red),
                label: const Text("Netejar", style: TextStyle(color: Colors.red)),
              )
            ],
          ),
        ),

        //cuerpo
        Builder(
            builder: (graellaContext) {
              return Listener( //Listener rastrea la posición exacta (coordenadas X e Y) de tu ratón mientras lo mueves sin soltar el botón (onPointerMove).
                onPointerMove: (event) => _gestionarInteraccioDrag(graellaContext, event.position),
                child: GestureDetector( //Por si haces clic entre dos asientos no haga nada
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate((totalSeients / columnes).ceil(), (rowIndex) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: rowIndex < ((totalSeients / columnes).ceil() - 1) ? 10.0 : 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(columnes, (colIndex) {
                              final seientId = (rowIndex * columnes) + colIndex + 1;

                              if (seientId > totalSeients) return SizedBox(width: midaSeient);

                              final isSelected = estat.seleccionats.contains(seientId);
                              final isConfirmed = estat.confirmats.contains(seientId);

                              Color bgColor = estat.colorLliure;
                              if (isConfirmed) bgColor = estat.colorConfirmat;
                              else if (isSelected) bgColor = estat.colorSeleccionat;

                              return Padding(
                                padding: EdgeInsets.only(right: colIndex < columnes - 1 ? 10.0 : 0),
                                child: MouseRegion(
                                  cursor: isConfirmed ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                                  child: GestureDetector(
                                    // El clic normal continua funcionant per seleccionar/deseleccionar d'1 en 1
                                    onTapDown: (_) => _processarSeleccio(seientId),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: midaSeient,
                                      height: midaSeient,
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(borderRadius),
                                        border: Border.all(
                                          color: isSelected ? Colors.black54 : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        seientId.toString(),
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              );
            }
        ),
      ],
    );
  }

  /// Processa la selecció (o deselecció) d'un seient, EL CLIC
  void _processarSeleccio(int seientId) {
    if (estat.confirmats.contains(seientId)) return; // si esta confirmado no hace nada

    final llistaActual = List<int>.from(estat.seleccionats);

    if (llistaActual.contains(seientId)) { // si esta marcado desmarca
      llistaActual.remove(seientId);
      onSelected(llistaActual);
    } else { //sino marca
      if (llistaActual.length >= estat.maxSeleccionables) {
        onMaxReached();
      } else {
        llistaActual.add(seientId);
        onSelected(llistaActual);
      }
    }
  }

  /// GPS DEL RATON dice coordenada, X    Y
  /// RenderBox averigua dónde está esa caja blanca en la pantalla, y globalToLocal hace la traducción. Ahora localPosition nos dice algo como: "El ratón está a 50 píxeles del borde izquierdo de la caja blanca".
  void _gestionarInteraccioDrag(BuildContext context, Offset globalPosition) {
    // 1. Obtenim la "caixa física" de la graella per entendre les seves dimensions a la pantalla.
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return; // Si no existe la caja no hace nada

    // 2. Traduïm les coordenades del ratolí: de globals (tota la pantalla) a locals (dins la caixa blanca).
    final Offset localPosition = box.globalToLocal(globalPosition);

    // 3. Definim quant d'espai ocupa una "cel·la" completa (el seient + el marge dret/inferior de 10px).
    final double espaiElement = midaSeient + 10;

    // 4. Calculem la Fila i Columna exacta on està el ratolí.
    // - Restem 16px per ignorar el padding de la vora de la caixa blanca.
    // - Dividim per l'espaiElement per saber a quina casella correspon.
    // - .floor() elimina els decimals per donar-nos un índex sencer (ex: columna 2).
    int col = ((localPosition.dx - 16) / espaiElement).floor();
    int row = ((localPosition.dy - 16) / espaiElement).floor();

    // 5. Comprovem que el ratolí estigui dins dels límits vàlids de les columnes i files.
    if (col >= 0 && col < columnes && row >= 0) {

      // 6. Fórmula màgica: Converteix la posició 2D (fila/columna) en un ID de seient 1D (ex: Seient 14).
      int possibleId = (row * columnes) + col + 1;

      // 7. Ens assegurem que el seient calculat existeix realment (evitem marcar "seients fantasma" al final).
      if (possibleId > 0 && possibleId <= totalSeients) {

        // 8. En arrossegar, només marquem seients nous (no desmarquem per error).
        // Si el seient NO està ja verd (seleccionats) i NO està venut (confirmats), el processem.
        if (!estat.seleccionats.contains(possibleId) && !estat.confirmats.contains(possibleId)){
          _processarSeleccio(possibleId); // Cridem la funció que l'afegeix a la llista i avisa la UI.
        }
      }
    }
  }
}