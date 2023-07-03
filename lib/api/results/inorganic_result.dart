class InorganicResult {
  final bool present;
  final String? formula;
  final String? stockName, systematicName, traditionalName, commonName;
  final String? molecularMass, density, meltingPoint, boilingPoint;

  InorganicResult({
    required this.present,
    this.formula,
    this.stockName,
    this.systematicName,
    this.traditionalName,
    this.commonName,
    this.molecularMass,
    this.density,
    this.meltingPoint,
    this.boilingPoint,
  });

  /* 
    * Why using Map<String, dynamic> instead of String?
      Because the JSON is a Map<String, dynamic> object and we need to convert it to a String object
      and then to a Map<String, dynamic> object again in order to use it.
  **/

  // Add the fromJson method to deserialize the JSON
  factory InorganicResult.fromJson(Map<String, dynamic> json) {
    return InorganicResult(
      present: json['present'] as bool,
      formula: json['formula'] as String?,
      stockName: json['stockName'] as String?,
      systematicName: json['systematicName'] as String?,
      traditionalName: json['traditionalName'] as String?,
      commonName: json['commonName'] as String?,
      molecularMass: json['molecularMass'] as String?,
      density: json['density'] as String?,
      meltingPoint: json['meltingPoint'] as String?,
      boilingPoint: json['boilingPoint'] as String?,
    );
  }
  // Add the toJson method to serialize the object
  Map<String, dynamic> toJson() {
    return {
      // Serialize the properties of the InorganicResult
      'present': present,
      'formula': formula,
      'stockName': stockName,
      'systematicName': systematicName,
      'traditionalName': traditionalName,
      'commonName': commonName,
      'molecularMass': molecularMass,
      'density': density,
      'meltingPoint': meltingPoint,
      'boilingPoint': boilingPoint,
    };
  }

  @override
  String toString() {
    List<String?> identifiers = [
      formula,
      stockName,
      systematicName,
      traditionalName,
      commonName,
      molecularMass,
      density,
      meltingPoint,
      boilingPoint,
    ];

    identifiers.removeWhere((identifier) => identifier == null);

    return identifiers.toString();
  }
}
