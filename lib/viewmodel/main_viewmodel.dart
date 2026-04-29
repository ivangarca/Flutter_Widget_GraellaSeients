import 'package:flutter/material.dart';
import '../../model/graella_seients_state.dart';

// Avisa a la vista amb notifyListeners() quan hi ha canvis.
// el ViewModel no puede "tocar" la pantalla directamente. Lo que hace es usar este changeNotifier para avisar de los cambios y que la vista los haga.
class MainViewModel extends ChangeNotifier {
  // que empieze por _ es que es privada
  GraellaSeientsState _estatGraella;

  // GET para mostrar datos
  GraellaSeientsState get estatGraella => _estatGraella;

  //CONSTRUCTOR
  MainViewModel(this._estatGraella);
  int _files = 5;
  int _columnes = 8;

  int get files => _files;
  int get columnes => _columnes;
  int get totalSeients => _files * _columnes;

  /// Mètode per canviar les dimensions des del Pop-up
  void actualitzarDimensions(int novesFiles, int novesColumnes) {
    if (novesFiles <= 0 || novesColumnes <= 0) return; // Asi miramos que ponga dos numeros positivos

    _files = novesFiles;
    _columnes = novesColumnes;

    // como es otra sala vaciamos las lstas
    _estatGraella = _estatGraella.copyWith(
      seleccionats: const [],
      confirmats: const [],
    );

    notifyListeners(); // avisa que ha cambiado
  }


  //para cuando el usuario clica
  void actualitzarSeleccio(List<int> novaLlista) {
    _estatGraella = _estatGraella.copyWith(seleccionats: novaLlista);

    notifyListeners();
  }

  /// muestra el  mensaje en el log si el usuario clica más de 5
  void avisarLimitAssolit() {
    debugPrint("⚠️ LÍMIT ASSOLIT! L'usuari ha intentat seleccionar més de ${_estatGraella.maxSeleccionables} seients.");
  }

  /// quita la lista de verdes
  void netejarSeleccio() {
    _estatGraella = _estatGraella.copyWith(seleccionats: const []);
    notifyListeners();
  }

  void confirmarSeleccio() {
    // mira queno este vacio
    if (_estatGraella.seleccionats.isEmpty) return;

    // 2. Copiamos los asientos que YA estaban ocupados y le añadimos
    // de golpe (usando ..addAll) los nuevos asientos seleccionados.
    final nousConfirmats = List<int>.from(_estatGraella.confirmats)
      ..addAll(_estatGraella.seleccionats);

    // 3. Actualizamos la caja fuerte (el estado):
    // Guardamos la nueva lista de ocupados y dejamos los seleccionados vacíos.
    _estatGraella = _estatGraella.copyWith(
      confirmats: nousConfirmats,
      seleccionats: const [], // Al vaciarlo, desaparece el color verde
    );

    // Avisamos del cambio.
    notifyListeners();
  }
}