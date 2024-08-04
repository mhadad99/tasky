class OneTaskModel {
  String? sId;
  String? image;
  String? title;
  String? desc;
  String? priority;
  String? status;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? iV;

  OneTaskModel(
      {this.sId,
      this.image,
      this.title,
      this.desc,
      this.priority,
      this.status,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV});

  OneTaskModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    title = json['title'];
    desc = json['desc'];
    priority = json['priority'];
    status = json['status'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['image'] = image;
    data['title'] = title;
    data['desc'] = desc;
    data['priority'] = priority;
    data['status'] = status;
    data['user'] = user;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
