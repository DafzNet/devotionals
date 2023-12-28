
class Book {
    String? name;
    List<Chapter?>? chapters;

    Book({this.name, this.chapters}); 

    Book.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        if (json['chapters'] != null) {
         chapters = <Chapter>[];
         json['chapters'].forEach((v) {
         chapters!.add(Chapter.fromJson(v));
        });
      }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['name'] = name;
        data['chapters'] =chapters != null ? chapters!.map((v) => v?.toJson()).toList() : null;
        return data;
    }
}

class Chapter {
    List<Verse?>? verses;
    int? num;

    Chapter({this.verses, this.num}); 

    Chapter.fromJson(Map<String, dynamic> json) {
        if (json['verses'] != null) {
         verses = <Verse>[];
         json['verses'].forEach((v) {
         verses!.add(Verse.fromJson(v));
        });
      }
        num = json['num'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['verses'] =verses != null ? verses!.map((v) => v?.toJson()).toList() : null;
        data['num'] = num;
        return data;
    }
}

class Root {
    String? version;
    List<Book?>? books;

    Root({this.version, this.books}); 

    Root.fromJson(Map<String, dynamic> json) {
        version = json['version'];
        if (json['books'] != null) {
         books = <Book>[];
         json['books'].forEach((v) {
         books!.add(Book.fromJson(v));
        });
      }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['version'] = version;
        data['books'] =books != null ? books!.map((v) => v?.toJson()).toList() : null;
        return data;
    }
}

class Verse {
    String? text;
    int? num;

    Verse({this.text, this.num}); 

    Verse.fromJson(Map<String, dynamic> json) {
        text = json['text'];
        num = json['num'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['text'] = text;
        data['num'] = num;
        return data;
    }
}

