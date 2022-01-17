class VersesModel {
  List<Verses>? verses;

  VersesModel({this.verses});

  VersesModel.fromJson(Map<String, dynamic> json) {
    if (json['verses'] != null) {
      verses = <Verses>[];
      json['verses'].forEach((v) {
        verses!.add(new Verses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.verses != null) {
      data['verses'] = this.verses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verses {
  int? id;
  String? verseKey;
  String? textUthmani;

  Verses({this.id, this.verseKey, this.textUthmani});

  Verses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    verseKey = json['verse_key'];
    textUthmani = json['text_uthmani'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['verse_key'] = this.verseKey;
    data['text_uthmani'] = this.textUthmani;
    return data;
  }
}
