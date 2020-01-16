class Note {
  int _id;
  String _title;
  String _desc;

  //! Konstruktor versi 1
  Note(this._title, this._desc);

  //! Konstruktor versi 2: Konversi dari Map ke Note
  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._desc = map['desc'];
  }

  //! Getter dan Setter (Mengambil dan mengisi data ke dalam object)
  //? Getter
  int get id => _id;
  String get title => _title;
  String get desc => _desc;

  //? Setter
  set titleSet(String value) {
    _title = value;
  }

  //? Setter
  set descSet(String value) {
    _desc = value;
  }

  //! Konversi dari Note ke Map

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['title'] = title;
    map['desc'] = desc;
    return map;
  }

}