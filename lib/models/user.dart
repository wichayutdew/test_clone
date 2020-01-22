class User {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;
  String pushToken;
  String chatWith;

  User({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
    this.pushToken,
    this.chatWith
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["status"] = user.status;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    data["pushToken"] = user.pushToken;
    data["chatWith"] = user.chatWith;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.pushToken = mapData['pushToken'];
    this.chatWith = mapData['chatWith'];
  }
}