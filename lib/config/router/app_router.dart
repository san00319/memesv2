import 'package:go_router/go_router.dart';
import 'package:memesv2/views/login/login_view.dart'; // Importa la vista del login
import 'package:memesv2/views/categories/category_create_view.dart';
import 'package:memesv2/views/categories/category_edit_view.dart';
import 'package:memesv2/views/categories/category_list_view.dart';
import 'package:memesv2/views/memes/meme_create.dart';
import 'package:memesv2/views/memes/meme_edit.dart';
import 'package:memesv2/views/memes/meme_list.dart';
import 'package:memesv2/views/roles/roles_create_view.dart';
import 'package:memesv2/views/roles/roles_delete_view.dart';
import 'package:memesv2/views/roles/roles_edit_view.dart';
import 'package:memesv2/views/roles/roles_list_view.dart';
import 'package:memesv2/views/entidad/entidad_create_view.dart';
import 'package:memesv2/views/entidad/entidad_edit_view.dart';
import 'package:memesv2/views/entidad/entidad_delete_view.dart';
import 'package:memesv2/views/entidad/entidad_list_view.dart';
import 'package:memesv2/views/user/user_create_view.dart';
import 'package:memesv2/views/user/user_delete_view.dart';
import 'package:memesv2/views/user/user_edit_view.dart';
import 'package:memesv2/views/user/user_list_view.dart';
import 'package:memesv2/views/ubicacion/ubicacion_create_view.dart';
import 'package:memesv2/views/ubicacion/ubicacion_delete_view.dart';
import 'package:memesv2/views/ubicacion/ubicacion_edit_view.dart';
import 'package:memesv2/views/ubicacion/ubicacion_list_view.dart';
import 'package:memesv2/views/puntoRecoleccion/puntoRecoleccion_list_view.dart';
import 'package:memesv2/views/puntoRecoleccion/puntoRecoleccion_create_view.dart';
import 'package:memesv2/views/puntoRecoleccion/puntoRecoleccion_edit_view.dart';
import 'package:memesv2/views/puntoRecoleccion/puntoRecoleccion_delete_view.dart';
import 'package:memesv2/views/categoria/categoria_edit_view.dart';
import 'package:memesv2/views/categoria/categoria_delete_view.dart';
import 'package:memesv2/views/categoria/categoria_create_view.dart';
import 'package:memesv2/views/categoria/categoria_list_view.dart';


class AppRouter {
  static GoRouter router(bool isLoggedIn) {
    return GoRouter(
      initialLocation: isLoggedIn ? '/' : '/login', // Redirige a login si no está autenticado
      routes: [
        // Ruta para el login
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginView(),
        ),
        // Ruta para listar categorías
        GoRoute(
          path: '/',
          builder: (context, state) => const CategoryList(),
        ),
        // Ruta para crear una nueva categoría
        GoRoute(
          path: '/create',
          builder: (context, state) => const CategoryCreate(),
        ),
        // Ruta para editar una categoría existente
        GoRoute(
          path: '/edit/:id',
          builder: (context, state) {
            final id = state.params['id']!;
            return CategoryEdit(id: id);
          },
        ),
        // Ruta para listar memes
        GoRoute(
          path: '/memes',
          builder: (context, state) => const MemeList(),
        ),
        // Ruta para crear un nuevo meme
        GoRoute(
          path: '/memes/create',
          builder: (context, state) => const MemeCreate(),
        ),
        // Ruta para editar un meme existente
        GoRoute(
          path: '/memes/edit/:id',
          builder: (context, state) {
            final id = state.params['id']!;
            return MemeEdit(id: id);
          },
        ),

        // Rutas para Roles
        GoRoute(
          path: '/roles',
          builder: (context, state) => const RoleList(),
        ),
        GoRoute(
          path: '/roles/create',
          builder: (context, state) => const RoleCreate(),
        ),
        GoRoute(
          path: '/roles/edit/:id',
          builder: (context, state) {
            final idrol = state.params['id']!;
            return RoleEdit(idrol: idrol);
          },
        ),
        GoRoute(
          path: '/roles/delete/:id',
          builder: (context, state) {
            final idrol = state.params['id']!;
            return RoleDelete(idrol: idrol);
          },
        ),

        // Rutas para Entidades
        GoRoute(
          path: '/entidades',
          builder: (context, state) => const EntidadList(),
        ),
        GoRoute(
          path: '/entidades/create',
          builder: (context, state) => const EntidadCreate(),
        ),
        GoRoute(
          path: '/entidades/edit/:id',
          builder: (context, state) {
            final identidad = state.params['id']!;
            return EntidadEdit(identidad: identidad);
          },
        ),
        GoRoute(
          path: '/entidades/delete/:id',
          builder: (context, state) {
            final identidad = state.params['id']!;
            return EntidadDelete(identidad: identidad);
          },
        ),

        // Rutas para Usuarios
        GoRoute(
          path: '/usuarios',
          builder: (context, state) => const UserList(),
        ),
        GoRoute(
          path: '/usuarios/create',
          builder: (context, state) => const UserCreate(),
        ),
        GoRoute(
          path: '/usuarios/edit/:id',
          builder: (context, state) {
            final idusuario = state.params['id']!;
            return UserEdit(idusuario: idusuario);
          },
        ),
        GoRoute(
          path: '/usuarios/delete/:id',
          builder: (context, state) {
            final idusuario = state.params['id']!;
            return UserDelete(idusuario: idusuario);
          },
        ),

        // Rutas para Ubicaciones
        GoRoute(
          path: '/ubicaciones',
          builder: (context, state) => const UbicacionList(),
        ),
        GoRoute(
          path: '/ubicaciones/create',
          builder: (context, state) => const UbicacionCreate(),
        ),
        GoRoute(
          path: '/ubicaciones/edit/:id',
          builder: (context, state) {
            final idubicacion = state.params['id']!;
            return UbicacionEdit(idubicacion: idubicacion);
          },
        ),
        GoRoute(
          path: '/ubicaciones/delete/:id',
          builder: (context, state) {
            final idubicacion = state.params['id']!;
            return UbicacionDelete(idubicacion: idubicacion);
          },
        ),

        // Rutas para Puntos de Recolección
        GoRoute(
          path: '/puntosrecoleccion',
          builder: (context, state) => const PuntoRecoleccionList(),
        ),
        GoRoute(
          path: '/puntosrecoleccion/create',
          builder: (context, state) => const PuntoRecoleccionCreate(),
        ),
        GoRoute(
          path: '/puntosrecoleccion/edit/:id',
          builder: (context, state) {
            final idpunto = state.params['id']!;
            return PuntoRecoleccionEdit(idpunto: idpunto);
          },
        ),
        GoRoute(
          path: '/puntosrecoleccion/delete/:id',
          builder: (context, state) {
            final idpunto = state.params['id']!;
            return PuntoRecoleccionDelete(idpunto: idpunto);
          },
        ),

        // Rutas para categorías
        GoRoute(
          path: '/categorias',  // Lista de categorías
          builder: (context, state) => const CategoriaList(),
        ),
        GoRoute(
          path: '/categorias/create',  // Crear nueva categoría
          builder: (context, state) => const CategoriaCreate(),
        ),
        GoRoute(
          path: '/categorias/edit/:id',  // Editar categoría
          builder: (context, state) {
            final idcategoria = state.params['id']!;
            return CategoriaEdit(idcategoria: idcategoria);
          },
        ),
        GoRoute(
          path: '/categorias/delete/:id',
          builder: (context, state) {
            final idcategoria = state.params['id']!;
            return CategoriaDelete(idcategoria: idcategoria);
          },
        ),
      ],
    );
  }
}
