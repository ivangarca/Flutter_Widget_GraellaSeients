# ivangarcia_greallaseients_widgets

Aquesta és una aplicació interactiva desenvolupada amb Flutter que permet simular la reserva de seients d'una sala (cinema, teatre, etc.). 
Està construïda seguint de manera estricta l'arquitectura  MVVM (Model-View-ViewModel) i utilitza `Provider` per a la gestió de l'estat.

## Getting Started

### Gestos i Controls Principals:
* **Clic Simple (Tap):** Fes clic sobre qualsevol seient lliure (gris clar) per seleccionar-lo (es tornarà verd). Si tornes a fer clic sobre un seient verd, es desmarcarà.
* **Arrossegar (Drag-to-Select):** Fes clic i mantén premut el ratolí (o el dit) sobre la graella i mou-lo per seleccionar múltiples seients ràpidament de forma fluida.
* **Clic al Fons (Deselecció ràpida):** Si fas clic a qualsevol zona buida de l'aplicació (fora de la graella blanca), s'esborrarà automàticament la teva selecció actual.
* **Scroll Forçat:** Si la pantalla és petita o la sala molt gran, pots utilitzar la barra lateral dreta per baixar.

### Botons d'Acció:
* **Netejar (Text vermell):** Bueda la llista de seients seleccionats actualment.
* **Confirmar Reserva:** Un cop tinguis seients verds, prem aquest botó. Els seients passaran a ser "Confirmats" (gris fosc) i ja no es podran modificar ni clicar.
* **Mida (Botó fosc flotant):** Obre un menú emergent que et permet canviar matemàticament el número de files i columnes de la sala. *Nota: En aplicar una nova mida, la sala es reiniciarà.*




















This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
