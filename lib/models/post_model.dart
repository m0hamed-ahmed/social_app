class PostModel {
  String userId;
  String name;
  String image;
  String dateTime;
  String text;
  String postImage;

  PostModel({this.userId, this.name, this.image, this.dateTime, this.text, this.postImage});

  PostModel.fromJson(Map<String, dynamic> json) {
    userId = json['uid'];
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid' : userId,
      'name' : name,
      'image' : image,
      'dateTime' : dateTime,
      'text' : text,
      'postImage' : postImage,
    };
  }
}