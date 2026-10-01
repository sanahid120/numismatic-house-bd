class CategoryData {
  final String title;
  final String imageUrl;
  final String itemCount;

  CategoryData(this.title, this.imageUrl, this.itemCount);
}

final List<CategoryData> categories = [
  CategoryData(
    'Bangladeshi Notes',
    'https://images.unsplash.com/photo-1628527304948-06157ee3c8a6?q=80&w=600&fit=crop',
    '120+ Items',
  ),
  CategoryData(
    'Pakistani Notes',
    'https://images.unsplash.com/photo-1599059813005-11265ba4b4ce?q=80&w=600&fit=crop',
    '85+ Items',
  ),
  CategoryData(
    'Foreign Notes',
    'https://images.unsplash.com/photo-1502920514313-52581002a659?q=80&w=600&fit=crop',
    '240+ Items',
  ),
];
