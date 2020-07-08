class mejaModel{
  String idMeja, keterangan;

  mejaModel({this.idMeja, this.keterangan});

  mejaModel.fromMap(Map snapshot, String id):
        idMeja = id ??'',
        keterangan = snapshot['keterangan'] ??'';

  toJson(){
    return{
      "keterangan" : keterangan
    };
  }
}