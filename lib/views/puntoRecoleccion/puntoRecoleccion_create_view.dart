import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/puntoRecoleccion_service.dart';
import 'package:memesv2/services/entidad_service.dart';
import 'package:memesv2/services/ubicacion_service.dart';
import 'package:memesv2/models/entidad.dart';
import 'package:memesv2/models/ubicacion.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class PuntoRecoleccionCreate extends StatefulWidget {
  const PuntoRecoleccionCreate({super.key});

  @override
  State<PuntoRecoleccionCreate> createState() => _PuntoRecoleccionCreateState();
}

class _PuntoRecoleccionCreateState extends State<PuntoRecoleccionCreate> {
  // Clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _nombrePuntoController = TextEditingController();

  // Instancias de los servicios
  final PuntoRecoleccionService _puntoRecoleccionService = PuntoRecoleccionService();
  final EntidadService _entidadService = EntidadService();
  final UbicacionService _ubicacionService = UbicacionService();

  // Variables para las listas de entidades y ubicaciones
  List<Entidad> _entidades = [];
  List<Ubicacion> _ubicaciones = [];

  // Variables seleccionadas
  Entidad? _selectedEntidad;
  Ubicacion? _selectedUbicacion;

  @override
  void initState() {
    super.initState();
    _fetchEntidadesAndUbicaciones(); // Cargar entidades y ubicaciones cuando la vista se inicie
  }

  // Método para obtener entidades y ubicaciones
  Future<void> _fetchEntidadesAndUbicaciones() async {
    try {
      final entidades = await _entidadService.getEntidades();
      final ubicaciones = await _ubicacionService.getUbicaciones();
      setState(() {
        _entidades = entidades;
        _ubicaciones = ubicaciones;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar entidades y ubicaciones: $e')),
      );
    }
  }

  // Método para manejar la creación del punto de recolección
  void _createPuntoRecoleccion() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _puntoRecoleccionService.createPuntoRecoleccion(
          _nombrePuntoController.text,
          _selectedEntidad!.identidad, // Verifica que haya una entidad seleccionada
          _selectedUbicacion!.idubicacion // Verifica que haya una ubicación seleccionada
        );

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Punto de recolección creado con éxito')),
        );

        // Regresar a la lista de puntos de recolección
        context.go('/puntosRecoleccion');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el punto de recolección: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Liberar los controladores cuando ya no sean necesarios
    _nombrePuntoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Punto de Recolección'),
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo para el nombre del punto de recolección
              TextFormField(
                controller: _nombrePuntoController,
                decoration: const InputDecoration(labelText: 'Nombre del Punto de Recolección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del punto de recolección';
                  } else if (value.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dropdown para seleccionar una entidad
              DropdownButtonFormField<Entidad>(
                decoration: const InputDecoration(labelText: 'Entidad'),
                items: _entidades.map((entidad) {
                  return DropdownMenuItem(
                    value: entidad,
                    child: Text(entidad.nombreEntidad),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEntidad = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una entidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dropdown para seleccionar una ubicación
              DropdownButtonFormField<Ubicacion>(
                decoration: const InputDecoration(labelText: 'Ubicación'),
                items: _ubicaciones.map((ubicacion) {
                  return DropdownMenuItem(
                    value: ubicacion,
                    child: Text(ubicacion.nombreUbicacion), // Asegúrate de que tu modelo tenga este atributo
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUbicacion = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una ubicación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Botón para crear el punto de recolección
              ElevatedButton(
                onPressed: _createPuntoRecoleccion,
                child: const Text('Crear Punto de Recolección'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
