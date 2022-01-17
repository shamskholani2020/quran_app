class AudioFiles {
  String? verseKey;
  String? url;

  AudioFiles({this.verseKey, this.url});

  AudioFiles.fromJson(Map<String, dynamic> json) {
    verseKey = json['verse_key'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verse_key'] = this.verseKey;
    data['url'] = this.url;
    return data;
  }
}
