class userModel{
  String idUser, email, noHp, password, status, tenanId, username;

  userModel({this.email, this.noHp, this.password, this.status, this.tenanId, this.username, this.idUser});

  userModel.fromMap(Map snapshot, String id):
        idUser = id ??'',
        email = snapshot['email'] ?? '',
        noHp = snapshot['noHp'] ?? '',
        password = snapshot['password'] ?? '',
        status = snapshot['status'] ?? '',
        tenanId = snapshot['tenanId'] ?? '',
        username = snapshot['username'] ?? '';

  toJson(){
    return{
      "email" : email,
      "noHp" : noHp,
      "password" : password,
      "status" : status,
      "tenanId" : tenanId,
      "username" : username
    };
  }
}