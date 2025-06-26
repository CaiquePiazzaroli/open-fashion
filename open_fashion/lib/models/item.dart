class Item {
  final String? id;
  final String imagePath;
  final String title;
  final String subTitle;
  final double price;

  //Color e size é opcional, sua utilização depende de onde o item está sendo renderizado
  late String? color;
  late String? size;

  Item({
    this.id, 
    required this.imagePath, 
    required this.title, 
    required this.subTitle, 
    required this.price, 
    this.color, 
    this.size});

  String getImagePath() => imagePath; 
  String getTitle() => title; 
  String getSubtitle() => subTitle; 
  double getPrice() => price; 
}