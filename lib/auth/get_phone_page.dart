// import 'dart:async';
// import 'dart:convert';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:relifnow_frontend_v2/authentication/phoneSignin/phone_auth.dart';
// import 'package:relifnow_frontend_v2/models/countries.dart';
import 'package:relifnow_frontend_v2/providers/user_provider.dart';
import 'package:relifnow_frontend_v2/screens/authentication/otp_reset_password.dart';
import 'package:relifnow_frontend_v2/universal/universal_variables.dart';

class GetPhoneNumberSceen extends StatefulWidget {
  @override
  _GetPhoneNumberSceenState createState() => _GetPhoneNumberSceenState();
}

class _GetPhoneNumberSceenState extends State<GetPhoneNumberSceen> {
  // List<Country> countries = [
  //   new Country(
  //     name: "Thailand",
  //     flag: "🇹🇭",
  //     code: "TH",
  //     dialCode: "+66",
  //   )
  // ];
  // StreamController<List<Country>> _countriesStreamController;
  // Stream<List<Country>> _countriesStream;
  // Sink<List<Country>> _countriesSink;

  TextEditingController _searchCountryController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  // int _selectedCountryIndex = 0;

  @override
  void dispose() {
    _searchCountryController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadCountriesJson().then((List<Country> list) {
  //     setState(() {
  //       countries = list;
  //     });
  //   });
  // }

  // Future<List<Country>> loadCountriesJson() async {
  //   List<Country> countries = [
  //     new Country(
  //       name: "Thailand",
  //       flag: "🇹🇭",
  //       code: "TH",
  //       dialCode: "+66",
  //     )
  //   ];
  //   String value = await DefaultAssetBundle.of(context)
  //       .loadString("assets/country_code.json");
  //   final countriesJson = json.decode(value);
  //   for (var i = 0; i < countriesJson.length; i++) {
  //     countries.add(Country.fromMap(countriesJson[i]));
  //   }
  //   return countries;
  // }

  @override
  Widget build(BuildContext context) {
    // final reLifNowLogo = Text(
    //   'ReLifNOW',
    //   style: TextStyle(
    //     color: Colors.white,
    //     fontSize: MediaQuery.of(context).size.width > 800 ? 50 : 35,
    //     fontWeight: FontWeight.normal,
    //   ),
    // );

    final sendOTPButton = RaisedButton(
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(8.0),
      ),
      child: Text(
        'ยืนยัน',
        style: UniversalTextStyle.heading2(Colors.white),
      ),
      onPressed: startPhoneAuth,
    );

    return ConnectivityWidgetWrapper(
      message: 'โปรดเชื่อมต่ออินเตอร์เน็ต',
      alignment: Alignment.bottomCenter,
      disableInteraction: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ลืมรหัสผ่าน',
            style: UniversalTextStyle.heading1(null),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Container(
          // margin: const EdgeInsets.only(top: 300),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Text('Select Country'),
              // selectCountryDropDown(countries[_selectedCountryIndex], showCountries),
              Text(
                'ใส่เบอร์มือถือที่ใช้สมัครบัญชี Relifnow',
                style: UniversalTextStyle.heading3(null),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // phoneNumberField(_phoneNumberController,
              //     countries[_selectedCountryIndex].dialCode),
              phoneNumberField(_phoneNumberController),
              SizedBox(height: 10),
              Container(
                child: sendOTPButton,
                height: 50,
              ),
            ],
          ),
        )),
      ),
    );
  }

  // Widget phoneNumberField(TextEditingController controller, String prefix) {
  Widget phoneNumberField(TextEditingController controller) {
    return Container(
      // height: 50,
      child: TextFormField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.phone,
        key: Key('EnterPhone-TextFormField'),
        decoration: InputDecoration(
          hintText: '0895845454',
          border: InputBorder.none,
          errorMaxLines: 1,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[200],
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          fillColor: Colors.white,
          filled: true,
          // prefix: Text("  " + prefix + "  "),
        ),
      ),
    );
  }

  // Widget selectCountryDropDown(Country country, Function onPressed) {
  //   return Card(
  //     child: InkWell(
  //       onTap: onPressed,
  //       child: Padding(
  //         padding: const EdgeInsets.only(
  //             left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
  //         child: Row(
  //           children: <Widget>[
  //             Expanded(child: Text(' ${country.flag}  ${country.name} ')),
  //             Icon(Icons.arrow_drop_down, size: 24.0)
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // static Widget searchCountry(TextEditingController controller) {
  //   return Padding(
  //     padding:
  //         const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
  //     child: Card(
  //       child: TextFormField(
  //         autofocus: true,
  //         controller: controller,
  //         decoration: InputDecoration(
  //             hintText: 'Search your country',
  //             contentPadding: const EdgeInsets.only(
  //                 left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
  //             border: InputBorder.none),
  //       ),
  //     ),
  //   );
  // }

  // static Widget selectableWidget(
  //     Country country, Function(Country) selectThisCountry) {
  //   return Material(
  //     color: Colors.white,
  //     type: MaterialType.canvas,
  //     child: InkWell(
  //       onTap: () => selectThisCountry(country), //selectThisCountry(country),
  //       child: Padding(
  //         padding: const EdgeInsets.only(
  //             left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
  //         child: Text(
  //           "  " +
  //               country.flag +
  //               "  " +
  //               country.name +
  //               " (" +
  //               country.dialCode +
  //               ")",
  //           style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // showCountries() {
  //   _countriesStreamController = StreamController();
  //   _countriesStream = _countriesStreamController.stream;
  //   _countriesSink = _countriesStreamController.sink;
  //   _countriesSink.add(countries);

  //   _searchCountryController.addListener(searchCountries);

  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => searchAndPickYourCountryHere(),
  //       barrierDismissible: false);
  // }

  // searchCountries() {
  //   String query = _searchCountryController.text;
  //   if (query.length == 0 || query.length == 1) {
  //     if (!_countriesStreamController.isClosed) _countriesSink.add(countries);
  //   } else if (query.length >= 2 && query.length <= 5) {
  //     List<Country> searchResults = [];
  //     searchResults.clear();
  //     countries.forEach((Country c) {
  //       if (c.name.toString().toLowerCase().contains(query.toLowerCase()))
  //         searchResults.add(c);
  //     });
  //     _countriesSink.add(searchResults);
  //   } else {
  //     //No results
  //     List<Country> searchResults = [];
  //     _countriesSink.add(searchResults);
  //   }
  // }

  // Widget searchAndPickYourCountryHere() => WillPopScope(
  //       onWillPop: () => Future.value(false),
  //       child: Dialog(
  //         key: Key('SearchCountryDialog'),
  //         elevation: 8.0,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  //         child: Container(
  //           margin: const EdgeInsets.all(5.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               searchCountry(_searchCountryController),
  //               SizedBox(
  //                 height: 300.0,
  //                 child: StreamBuilder<List<Country>>(
  //                     stream: _countriesStream,
  //                     builder: (context, snapshot) {
  //                       if (snapshot.hasData) {
  //                         return snapshot.data.length == 0
  //                             ? Center(
  //                                 child: Text('Your search found no results',
  //                                     style: TextStyle(fontSize: 16.0)),
  //                               )
  //                             : ListView.builder(
  //                                 itemCount: snapshot.data.length,
  //                                 itemBuilder: (BuildContext context, int i) =>
  //                                     selectableWidget(snapshot.data[i],
  //                                         (Country c) => selectThisCountry(c)),
  //                               );
  //                       } else if (snapshot.hasError)
  //                         return Center(
  //                           child: Text('Seems, there is an error',
  //                               style: TextStyle(fontSize: 16.0)),
  //                         );
  //                       return Center(child: CircularProgressIndicator());
  //                     }),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  // void selectThisCountry(Country country) {
  //   print(country);

  //   _searchCountryController.clear();

  //   Navigator.of(context).pop();

  //   Future.delayed(Duration(milliseconds: 10)).whenComplete(() {
  //     _countriesStreamController.close();
  //     _countriesSink.close();
  //     setState(() {
  //       _selectedCountryIndex = countries.indexOf(country);
  //     });
  //   });
  // }

  startPhoneAuth() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print(_phoneNumberController.text);
    Map<String, dynamic> response =
        await userProvider.checkUserByPhoneNumber(_phoneNumberController.text);
    print(response['msg']);
    if (response['msg'] == "Phone number Exist") {
      await FirebasePhoneAuth.startAuth(
          // phone: countries[_selectedCountryIndex].dialCode + _phoneNumberController.text);
          phone: '+66' + _phoneNumberController.text);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OTPResetPasswordScreen(
            // phoneNumber: countries[_selectedCountryIndex].dialCode + _phoneNumberController.text
            phoneNumber: '+66' + _phoneNumberController.text
          )
        )
      );
    } else if (response.containsKey('error')) {
      _showErrorDialog('An error occurs!', response['error'].toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          )
        ],
      ),
    );
  }
}
