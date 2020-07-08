class itemModel{
  String idItem, namaMakanan, kategori, dijual, harga, biaya;

  itemModel({this.idItem, this.kategori, this.biaya, this.dijual, this.harga, this.namaMakanan});

  itemModel.fromMap(Map snapshot, String id):
        idItem = id ??'',
        biaya = snapshot['biaya'] ??'',
        harga = snapshot['harga'] ??'',
        kategori = snapshot['kategori'] ??'',
        namaMakanan = snapshot['namaMakanan'] ??'';

  toJson(){
    return{
      "biaya" : biaya,
      "dijual" : dijual,
      "harga" : harga,
      "kategori" : kategori,
      "namaMakanan" : namaMakanan
    };
  }
}