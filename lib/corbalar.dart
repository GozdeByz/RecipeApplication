import 'package:flutter/material.dart';
import 'package:gozdetarifler/database_helper.dart';

class CorbaTarifleriSayfasi extends StatefulWidget {
  const CorbaTarifleriSayfasi({super.key});

  @override
  State<CorbaTarifleriSayfasi> createState() => _CorbaTarifleriSayfasiState();
}

class _CorbaTarifleriSayfasiState extends State<CorbaTarifleriSayfasi> {
  // Belirtilen kategoriye göre veritabanından tatlı tariflerini alır
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  late Future<List<Map<String, dynamic>>> futureRecipes;

  @override
  //widget durumu başlatıldıgında veritabanından tarifleri alır.
  void initState() {
    super.initState();
    futureRecipes = _getRecipesByCategory('Çorba');
  }

// Belirli bir kategoriye göre yemek tariflerini getiren fonksiyon
  Future<List<Map<String, dynamic>>> _getRecipesByCategory(
      String category) async {
// DatabaseHelper sınıfından getDessertRecipes yöntemi kullanılarak veritabanından veri alınır.
    var data = await DatabaseHelper.instance.getDessertRecipes(category);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold ekliyoruz
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
            // Veriler başarıyla alındıysa
            List<Map<String, dynamic>> recipes =
                snapshot.data!; // Alınan verileri bir listeye atama
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                // Her bir öğe için bir liste öğesi oluştur
                Map<String, dynamic> recipe = recipes[index];
                return Card(
                    child: ListTile(
                  leading: Image.network(recipe['imageUrl']),
                  title: Text(recipe['name']),
                  subtitle: Column(
                    // Alt öğelerin yatayda sol kenara hizalanmasını sağlamak için
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
                ));
              },
            );
          }
        },
      ),
    );
  }
}
