// lib/views/categories/category_list.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/category.dart';
import 'package:memesv2/services/category_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';
// Importamos el Drawer

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = _categoryService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Categorías'),
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  //crea la lista de categorias
                  title: Text(category.nombre),
                  subtitle: Text(category.descripcion),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      context.go('/edit/${category.id}');
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            //valida errores al cargar categorias.
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
