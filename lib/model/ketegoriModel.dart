class kategoriModel{
  String idKategori, keterangan;

  kategoriModel({this.idKategori, this.keterangan});

  kategoriModel.fromMap(Map snapshot, String id):
        idKategori = id ??'',
        keterangan = snapshot['keterangan'] ??'';

  toJson(){
    return{
      "keterangan" : keterangan
    };
  }
}