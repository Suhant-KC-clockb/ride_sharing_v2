class RiderDocs {
  int? userId;
  String? rideType;
  String? licenseNumber;
  String? transportName;
  String? numberPlate;
  String? transportModel;
  String? transportImg;
  String? licenseFrontImg;
  String? blueBook1Img;
  String? blueBook2Img;
  String? riderHoldingLicenseImg;
  String? transportImgUrl;
  String? licenseFrontImgUrl;
  String? blueBook1ImgUrl;
  String? blueBook2ImgUrl;
  String? riderHoldingLicenseImgUrl;
  String? createdAt;
  String? updatedAt;

  RiderDocs(
      {this.userId,
      this.rideType,
      this.licenseNumber,
      this.transportName,
      this.numberPlate,
      this.transportModel,
      this.transportImg,
      this.licenseFrontImg,
      this.blueBook1Img,
      this.blueBook2Img,
      this.riderHoldingLicenseImg,
      this.transportImgUrl,
      this.licenseFrontImgUrl,
      this.blueBook1ImgUrl,
      this.blueBook2ImgUrl,
      this.riderHoldingLicenseImgUrl,
      this.createdAt,
      this.updatedAt});

  RiderDocs.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    rideType = json['ride_type'];
    licenseNumber = json['license_number'];
    transportName = json['transport_name'];
    numberPlate = json['number_plate'];
    transportModel = json['transport_model'];
    transportImg = json['transport_img'];
    licenseFrontImg = json['license_front_img'];
    blueBook1Img = json['blue_book1_img'];
    blueBook2Img = json['blue_book2_img'];
    riderHoldingLicenseImg = json['rider_holding_license_img'];
    transportImgUrl = json['transport_img_url'];
    licenseFrontImgUrl = json['license_front_img_url'];
    blueBook1ImgUrl = json['blue_book1_img_url'];
    blueBook2ImgUrl = json['blue_book2_img_url'];
    riderHoldingLicenseImgUrl = json['rider_holding_license_img_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['ride_type'] = rideType;
    data['license_number'] = licenseNumber;
    data['transport_name'] = transportName;
    data['number_plate'] = numberPlate;
    data['transport_model'] = transportModel;
    data['transport_img'] = transportImg;
    data['license_front_img'] = licenseFrontImg;
    data['blue_book1_img'] = blueBook1Img;
    data['blue_book2_img'] = blueBook2Img;
    data['rider_holding_license_img'] = riderHoldingLicenseImg;
    data['transport_img_url'] = transportImgUrl;
    data['license_front_img_url'] = licenseFrontImgUrl;
    data['blue_book1_img_url'] = blueBook1ImgUrl;
    data['blue_book2_img_url'] = blueBook2ImgUrl;
    data['rider_holding_license_img_url'] = riderHoldingLicenseImgUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
