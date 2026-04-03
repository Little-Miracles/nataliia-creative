import 'package:flutter/material.dart';

class FoodItemsScreen extends StatefulWidget {
  final String categoryName;

  // Возвращаем стандартный конструктор, который ждет твой Navigator
  const FoodItemsScreen({super.key, required this.categoryName});

  @override
  State<FoodItemsScreen> createState() => _FoodItemsScreenState();
}

class _FoodItemsScreenState extends State<FoodItemsScreen> {
  // Те самые 12 категорий от Клода, про которые мы говорили
  final List<String> subCategories = [
    'ALL', 'MEAT', 'POULTRY', 'FISH', 'SEAFOOD', 'VEGETABLE', 
    'LEGUME', 'MUSHROOM', 'CREAM', 'BROTHS', 'COLD', 'ASIAN'
  ];
  
  String selectedSub = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          //widget.categoryName позволяет нам брать имя из родительского класса
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFD4AF37), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.categoryName.toUpperCase(), 
          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- ГОРИЗОНТАЛЬНАЯ СТРОЧКА КАТЕГОРИЙ (ФИЛЬТР) ---
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                bool isActive = selectedSub == subCategories[index];
                return GestureDetector(
                  onTap: () => setState(() => selectedSub = subCategories[index]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF8B5E3C) : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: const Color(0xFF8B5E3C), width: 0.8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      subCategories[index],
                      style: TextStyle(
                        color: isActive ? Colors.white : const Color(0xFF8B5E3C),
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- СПИСОК СУПОВ (ТВОИ ЛЮБИМЫЕ ЗОЛОТЫЕ СЛИТКИ) ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _buildJewelCard('Classic Borscht', '250', 'Beef, beets, cabbage'),
                _buildJewelCard('Green Sorrel Soup', '180', 'Sorrel, eggs, potatoes'),
                _buildJewelCard('Chicken Noodle', '150', 'Poultry, carrots, noodles'),
                _buildJewelCard('Pumpkin Cream', '320', 'Cream, pumpkin, seeds'),
                _buildJewelCard('Fish Ukha', '190', 'Salmon, potatoes, onions'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Наш финальный метод карточки (без изменений в дизайне)
  Widget _buildJewelCard(String name, String kcal, String desc) {
    const Color antiqueGold = Color(0xFF8B5E3C);
    const Color contentColor = Color(0xFFEDE6D6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [antiqueGold, Color(0xFF1B1811)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: antiqueGold.withOpacity(0.3), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(4, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(name.toUpperCase(), 
          style: const TextStyle(color: contentColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.2)),
        subtitle: Text(desc, style: TextStyle(color: contentColor.withOpacity(0.6), fontSize: 10)),
        trailing: Text('$kcal kcal', 
          style: const TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: 14)),
        onTap: () {
          // Здесь будет наше окно с ползунком
        },
      ),
    );
  }
}