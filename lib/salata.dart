import 'package:flutter/material.dart';
import 'package:gozdetarifler/database_helper.dart';

class SalataTarifleriSayfasi extends StatefulWidget {
  const SalataTarifleriSayfasi({super.key});

  @override
  State<SalataTarifleriSayfasi> createState() => _SalataTarifleriSayfasiState();
}

class _SalataTarifleriSayfasiState extends State<SalataTarifleriSayfasi> {
  // Belirtilen kategoriye göre veritabanından tatlı tariflerini alır
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  late Future<List<Map<String, dynamic>>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _getRecipesByCategory('Salata');
  }

  Future<List<Map<String, dynamic>>> _getRecipesByCategory(
      String category) async {
    var data = await DatabaseHelper.instance.getDessertRecipes(category);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold ekleyin
      appBar: AppBar(
        title: const Text(
          'Leziz Tarifler',
          style: TextStyle(
            color: Color.fromARGB(255, 131, 161, 180),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 63, 137, 167),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length, // Tarif listesindeki eleman sayısı
              itemBuilder: (context, index) {
                Map<String, dynamic> recipe =
                    recipes[index]; // Şu an işlenen tarifi alır
                return Card(
                    // Card widget'ını kullanarak ListTile'ı sarar
                    child: ListTile(
                  // Başlık öğesinin sol tarafında resim gösterir
                  leading: Image.network(recipe['imageUrl']),
                  title: Text(recipe['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe['ingredients']),
                      const SizedBox(height: 8),
                      const Text(
                        'YAPILIŞI:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(recipe['instructions']), // Yapılışını gösterir
                    ],
                  ),
                ));
              },
            );
          }
        },
      ),
    );
  }
}
