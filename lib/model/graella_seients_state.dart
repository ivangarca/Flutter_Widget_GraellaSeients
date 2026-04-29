import 'package:flutter/material.dart';  // lo uso para definir los colores de los asientos.
import 'package:flutter/foundation.dart'; // para usar el @immutable y el listEquals

@immutable //hace que no se pueda modificar, solo crear nuevos
class GraellaSeientsState {
  //ATRIBUTOS
  final List<int> seleccionats;
  final List<int> confirmats;
  final int maxSeleccionables;
  final Color colorSeleccionat;
  final Color colorLliure;
  final Color colorConfirmat;

  //CONSTRUCTOR
  const GraellaSeientsState({
    this.seleccionats = const [],
    this.confirmats = const [],
    this.maxSeleccionables = 5,
    this.colorSeleccionat = const Color(0xFF4CAF50), //verde
    this.colorLliure = const Color(0xFFE0E0E0), //gris claro
    this.colorConfirmat = const Color(0xFF9E9E9E),//gris oscuro
  });


  //Crea un clon exacto del estado actual, pero cambia lo que diga.
  //Los interrogantes (?) significan que estos datos son opcionales.
  //La doble interrogación "Si me has pasado un valor nuevo, usa el nuevo. Si no me has pasado nada, usa el que ya tenía.
  GraellaSeientsState copyWith({
    List<int>? seleccionats,
    List<int>? confirmats,
    int? maxSeleccionables,
    Color? colorSeleccionat,
    Color? colorLliure,
    Color? colorConfirmat,
  }) {
    return GraellaSeientsState(
      seleccionats: seleccionats ?? this.seleccionats,
      confirmats: confirmats ?? this.confirmats,
      maxSeleccionables: maxSeleccionables ?? this.maxSeleccionables,
      colorSeleccionat: colorSeleccionat ?? this.colorSeleccionat,
      colorLliure: colorLliure ?? this.colorLliure,
      colorConfirmat: colorConfirmat ?? this.colorConfirmat,
    );
  }


  //Le digo, dos GraellaSeientsState son iguales SÍ Y SOLO SÍ tienen exactamente los mismos colores, el mismo límite, y las mismas listas".
  //para comparar ñistas uso el listEquals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GraellaSeientsState &&
        listEquals(other.seleccionats, seleccionats) &&
        listEquals(other.confirmats, confirmats) &&
        other.maxSeleccionables == maxSeleccionables &&
        other.colorSeleccionat == colorSeleccionat &&
        other.colorLliure == colorLliure &&
        other.colorConfirmat == colorConfirmat;
  }


  //Aquí junto todos los datos y uso Object.hash() para que Dart genere un DNI único basado en la información que contiene.
  //Uso hashAll() para las listas porque contienen múltiples elementos dentro.
  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(seleccionats),
      Object.hashAll(confirmats), // Afegit al hash
      maxSeleccionables,
      colorSeleccionat,
      colorLliure,
      colorConfirmat,
    );
  }
}