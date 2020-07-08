class Transaksi {
  
  String id;
  String diskon, meja, pembeli, petugas, total, jam;
//  Timestamp tanggal;
  
  Transaksi({this.id, this.meja, this.diskon, this.pembeli, this.petugas, this.jam,
//    this.tanggal,
    this.total});
  
  Transaksi.fromMap(Map snapshot,String id) :
        id = id ?? '',
        meja = snapshot['meja'] ?? '',
        diskon = snapshot['diskon'] ?? '',
        pembeli = snapshot['namaPembeli'] ?? '',
        petugas = snapshot['petugas'] ?? '',
        jam = snapshot['jam'] ?? '',
//        tanggal = snapshot['tanggal'] ?? '',
        total = snapshot['totalTransaksi'] ?? '';

  toJson() {
    return {
      "meja":meja,
      "diskon":diskon,
      "namaPembeli":pembeli,
      "petugas":petugas,
      "jam":jam,
//      "tanggal":tanggal,
      "totalTransaksi":total,
    };
  }
}