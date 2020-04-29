class Country {
  String name;
  String code; 
  String dialCode; 
  String flag;

  Country({
    this.name,
    this.code,
    this.dialCode,
    this.flag,
    });

  Country.fromMap(Map<String, dynamic> mapData) {
    this.name = mapData["name"];
    this.code = mapData["code"];
    this.dialCode = mapData["dial_code"];
    this.flag = mapData["flag"];
  }
}