class RestrictedZipModel {
  int id;
  String zipcode;
  RestrictedZipModel({this.id, this.zipcode});

  RestrictedZipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zipcode'] = this.zipcode;
    return data;
  }
}
