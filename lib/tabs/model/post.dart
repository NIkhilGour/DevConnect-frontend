import 'package:devconnect/tabs/model/like.dart';
import 'package:devconnect/tabs/model/user.dart';

class Post {
  int? id;
  String? description;
  String? content;
  String? fileUrl;
  String? fileType;
  String? github;
  UserProfile? userProfile;
  int? likecout;
  List<Like>? likes;
  int? commentcount;
  List<Comments>? comments;
  List<TechSkills>? techSkills;
  bool? isconnected;

  Post(
      {this.id,
      this.description,
      this.content,
      this.fileUrl,
      this.fileType,
      this.github,
      this.userProfile,
      this.likecout,
      this.likes,
      this.commentcount,
      this.comments,
      this.techSkills,
      this.isconnected});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    content = json['content'];
    fileUrl = json['fileUrl'];
    fileType = json['fileType'];
    github = json['github'];
    userProfile = json['userProfile'] != null
        ? UserProfile.fromJson(json['userProfile'])
        : null;
    likecout = json['likecout'];
    if (json['likes'] != null) {
      likes = <Like>[].cast<Like>();
      json['likes'].forEach((v) {
        likes!.add(Like.fromJson(v));
      });
    }
    commentcount = json['commentcount'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    if (json['techSkills'] != null) {
      techSkills = <TechSkills>[];
      json['techSkills'].forEach((v) {
        techSkills!.add(TechSkills.fromJson(v));
      });
    }
    isconnected = json['isConnected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['content'] = content;
    data['fileUrl'] = fileUrl;
    data['fileType'] = fileType;
    data['github'] = github;
    data['isConnected'] = isconnected;
    if (userProfile != null) {
      data['userProfile'] = userProfile!.toJson();
    }
    data['likecout'] = likecout;
    if (likes != null) {
      data['likes'] = likes!.map((v) => v.toJson()).toList();
    }
    data['commentcount'] = commentcount;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    if (techSkills != null) {
      data['techSkills'] = techSkills!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Post copyWith({
    int? id,
    String? description,
    String? content,
    String? fileUrl,
    String? fileType,
    String? github,
    User? userProfile,
    int? likecout,
    List<Like>? likes,
    int? commentcount,
    List<dynamic>? comments,
    List<String>? techSkills,
    bool? isconnected,
  }) {
    return Post(
      id: id ?? this.id,
      description: description ?? this.description,
      content: content ?? this.content,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      github: github ?? this.github,
      userProfile: this.userProfile,
      likecout: likecout ?? this.likecout,
      likes: likes ?? this.likes,
      commentcount: commentcount ?? this.commentcount,
      comments: this.comments,
      techSkills: this.techSkills,
      isconnected: isconnected ?? this.isconnected,
    );
  }
}

class UserProfile {
  int? id;
  User? user;
  String? name;
  List<TechSkills>? techSkills;
  Null phoneNumber;
  String? profilePictureUrl;
  String? bio;
  String? dateofbirth;
  String? gender;
  String? location;

  UserProfile(
      {this.id,
      this.user,
      this.name,
      this.techSkills,
      this.phoneNumber,
      this.profilePictureUrl,
      this.bio,
      this.dateofbirth,
      this.gender,
      this.location});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    name = json['name'];
    if (json['techSkills'] != null) {
      techSkills = <TechSkills>[];
      json['techSkills'].forEach((v) {
        techSkills!.add(TechSkills.fromJson(v));
      });
    }
    phoneNumber = json['phoneNumber'];
    profilePictureUrl = json['profilePictureUrl'];
    bio = json['bio'];
    dateofbirth = json['dateofbirth'];
    gender = json['gender'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['name'] = name;
    if (techSkills != null) {
      data['techSkills'] = techSkills!.map((v) => v.toJson()).toList();
    }
    data['phoneNumber'] = phoneNumber;
    data['profilePictureUrl'] = profilePictureUrl;
    data['bio'] = bio;
    data['dateofbirth'] = dateofbirth;
    data['gender'] = gender;
    data['location'] = location;
    return data;
  }
}

class TechSkills {
  int? id;
  String? skill;

  TechSkills({this.id, this.skill});

  TechSkills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skill = json['skill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['skill'] = skill;
    return data;
  }
}

// class Likes {
//   int? id;
//   Post? post;
//   User? user;

//   Likes({this.id, this.post, this.user});

//   Likes.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     post = json['post'] != null ? Post.fromJson(json['post']) : null;
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     if (post != null) {
//       data['post'] = post!.toJson();
//     }
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     return data;
//   }
// }

class Comments {
  int? id;
  String? content;
  Post? post;
  User? user;

  Comments({this.id, this.content, this.post, this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    post = json['post'] != null ? Post.fromJson(json['post']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    if (post != null) {
      data['post'] = post!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
