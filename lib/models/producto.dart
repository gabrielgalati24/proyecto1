class Producto {
  String id;
  String nombre;
  String imagen;

  Producto({this.nombre = "", this.id = "", this.imagen = ""});

  factory Producto.fromJson(Map<String, dynamic> parsedJson) {
    return Producto(
        id: parsedJson['id'],
        nombre: parsedJson['nombre'] ?? '',
        imagen: parsedJson['imagen'] ?? '');
  }
}
