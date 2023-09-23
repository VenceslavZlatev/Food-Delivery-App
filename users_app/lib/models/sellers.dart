//retrieve the information from firebase for the sellers and will display it in the home_screen
class Sellers {
  String? sellerName;
  String? sellerUID;
  String? sellerEmail;
  String? sellerAvatarUrl;
  String? sellerPhone;
  String? sellerAddress;
  // in future get the seller city so it can compare with the customer address
  // and it will display only sellers which are in the same city
  //String? sellerAddress;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerEmail,
    this.sellerAvatarUrl,
    this.sellerPhone,
    this.sellerAddress,
  });

  Sellers.fromJSON(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerEmail = json["sellerEmail"];
    sellerAvatarUrl = json["sellerAvatarUrl"];
    sellerPhone = json["phone"];
    sellerAddress = json["address"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sellerUID"] = this.sellerUID;
    data["sellerName"] = this.sellerName;
    data["sellerEmail"] = this.sellerEmail;
    data["sellerAvatarUrl"] = this.sellerAvatarUrl;
    data["phone"] = this.sellerPhone;
    data["address"] = this.sellerAddress;
    return data;
  }
}
