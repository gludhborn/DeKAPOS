class UserTenan{
  String idTenan, alamatTenan, namaTenan;

  UserTenan({this.idTenan, this.alamatTenan, this.namaTenan});

  UserTenan.fromMap(Map snapshot, String id):
        idTenan = id ??'',
        alamatTenan = snapshot['alamatTenan'] ?? '',
        namaTenan = snapshot['namaTenan'] ?? '';

  toJson(){
    return{
      "alamatTenan" : alamatTenan,
      "namaTenan" : namaTenan,
    };
  }
}