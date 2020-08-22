class Products {
  final String image, title, description,id,catagory;
  bool hidden;
  final List<dynamic> imgDetail;
  final int price;
  Products({
    this.image,
    this.title,
    this.price,
    this.description,
    this.hidden,
    this.id,
    this.imgDetail,
    this.catagory
  });
}

