// To parse this JSON data, do
//
//     final ChatUser = ChatUserFromJson(jsonString);

import 'dart:convert';

ChatUser ChatUserFromJson(String str) => ChatUser.fromJson(json.decode(str));

String ChatUserToJson(ChatUser data) => json.encode(data.toJson());

class ChatUser {
    String? image;
    String? about;
    String? name;
    String? createdAt;
    String? lastActive;
    String? id;
    bool? isOnline;
    String? pushToken;
    String? email;

    ChatUser({
        this.image,
        this.about,
        this.name,
        this.createdAt,
        this.lastActive,
        this.id,
        this.isOnline,
        this.pushToken,
        this.email,
    });

    factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        image: json["image"],
        about: json["about"],
        name: json["name"],
        createdAt: json["created_at"],
        lastActive: json["last_active"],
        id: json["id"],
        isOnline: json["is_online"],
        pushToken: json["push_token"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "about": about,
        "name": name,
        "created_at": createdAt,
        "last_active": lastActive,
        "id": id,
        "is_online": isOnline,
        "push_token": pushToken,
        "email": email,
    };
}
