class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? picture;
  String? address;
  String? gender;
  String? dob;
  String? role;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? hasAccount;
  String? token;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.picture,
      this.address,
      this.gender,
      this.dob,
      this.role,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.hasAccount,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    picture = json['picture'];
    address = json['address'];
    gender = json['gender'];
    dob = json['dob'];
    role = json['role'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hasAccount = json['has_account'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['picture'] = picture;
    data['address'] = address;
    data['gender'] = gender;
    data['dob'] = dob;
    data['role'] = role;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['has_account'] = hasAccount;
    data['token'] = token;
    return data;
  }
}
