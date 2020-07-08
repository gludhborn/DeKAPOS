
class TransaksiList {
  String id;
  String foto, harga_jual, kategori, total, namaMakanan, jumlah;

  TransaksiList({this.id,  this.foto, this.harga_jual, this.kategori, this.total, this.namaMakanan, this.jumlah});

  TransaksiList.fromMap(Map snapshot,String id) :
        id = id ?? '',
        foto = snapshot['foto'] ?? '',
        harga_jual = snapshot['harga'] ?? '',
        kategori = snapshot['kategori'] ?? '',
        total = snapshot['total'] ?? '',
        namaMakanan = snapshot['namaMakanan'] ?? '',
        jumlah = snapshot['jumlah'] ?? '';

  toJson() {
    return {
      "foto":foto,
      "harga_jual":harga_jual,
      "kategori":kategori,
      "total":total,
      "namaMakanan":namaMakanan,
      "jumlah":jumlah,
    };
  }
}