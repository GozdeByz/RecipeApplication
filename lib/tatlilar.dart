import 'package:flutter/material.dart';
import 'package:gozdetarifler/database_helper.dart';

class TatliTarifleriSayfasi extends StatefulWidget {
  TatliTarifleriSayfasi({super.key});

  @override
  State<TatliTarifleriSayfasi> createState() => _TatliTarifleriSayfasiState();
}

class _TatliTarifleriSayfasiState extends State<TatliTarifleriSayfasi> {
  // Veritabanı yardımcı sınıfının örneği oluşturulur
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  // Future nesnesi, tatlı tariflerinin gelecekteki değerini tutar.
  late Future<List<Map<String, dynamic>>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _getRecipesByCategory('Tatli');
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
            List<Map<String, dynamic>> recipes =
                snapshot.data!; // Verileri alır ve tarifler listesine atar
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> recipe = recipes[index];
                return Card(
                  // Card widget'ını kullanarak ListTile'ı sarın
                  child: ListTile(
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
                        Text(recipe['instructions']),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
