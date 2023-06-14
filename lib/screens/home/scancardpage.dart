import 'dart:async';
import 'package:dmrtd/dmrtd.dart';
import 'package:dmrtd/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nfc_id_reader/modules/bloodtypes.dart';
import 'package:nfc_id_reader/modules/cities.dart';
import 'package:nfc_id_reader/modules/mrtd.dart';
import 'package:logging/logging.dart';
import 'package:nfc_id_reader/screens/home/detailspage.dart';
import 'package:rive/rive.dart';

String formatEfCom(final EfCOM efCom) {
  var str = "version: ${efCom.version}\n"
      "unicode version: ${efCom.unicodeVersion}\n"
      "DG tags:";

  for (final t in efCom.dgTags) {
    try {
      str += " ${dgTagToString[t]!}";
    } catch (e) {
      str += " 0x${t.value.toRadixString(16)}";
    }
  }
  return str;
}

// String formatMRZ(final MRZ mrz) {
//   return " doc code: ${mrz.documentCode}\n  doc No.: ${mrz.documentNumber}\n  country: ${mrz.country}\n  nationality: ${mrz.nationality}\n  First Name: ${mrz.firstName}\n  Last Name: ${mrz.lastName}\n  gender: ${mrz.gender}\n  date of birth: ${DateFormat.yMd().format(mrz.dateOfBirth)}\n  date of expiry: ${DateFormat.yMd().format(mrz.dateOfExpiry)}";
// }

String formatDG15(final EfDG15 dg15) {
  var str = "EF.DG15: ${dg15.aaPublicKey}\n"
      "  AAPublicKey\n"
      "    type: ";

  final rawSubPubKey = dg15.aaPublicKey.rawSubjectPublicKey();
  if (dg15.aaPublicKey.type == AAPublicKeyType.RSA) {
    final tvSubPubKey = TLV.fromBytes(rawSubPubKey);
    var rawSeq = tvSubPubKey.value;
    if (rawSeq[0] == 0x00) {
      rawSeq = rawSeq.sublist(1);
    }

    final tvKeySeq = TLV.fromBytes(rawSeq);
    final tvModule = TLV.decode(tvKeySeq.value);
    final tvExp = TLV.decode(tvKeySeq.value.sublist(tvModule.encodedLen));

    str += "RSA\n"
        "    exponent: ${tvExp.value.hex()}\n"
        "    modulus: ${tvModule.value.hex()}";
  } else {
    str += "EC\n    SubjectPublicKey: ${rawSubPubKey.hex()}";
  }
  return str;
}

String formatProgressMsg(String message, int percentProgress) {
  final p = (percentProgress / 20).round();
  final full = "🟢 " * p;
  final empty = "⚫ " * (5 - p);
  return "$message\n\n$full$empty";
}

class ScanCardPage extends StatelessWidget {
  static String id = "ScanCardPage";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: MrtdHomePage());
  }
}

class MrtdHomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MrtdHomePageState createState() => _MrtdHomePageState();
}

class _MrtdHomePageState extends State<MrtdHomePage> {
  var _alertMessage = "";
  final _log = Logger("mrtdeg.app");
  var _isNfcAvailable = false;
  var _isReading = false;
  final _mrzData = GlobalKey<FormState>();

  // mrz data
  final _docNumber = TextEditingController();
  final _doclongNumber = TextEditingController();
  final _pob = TextEditingController();
  final _dob = TextEditingController(); // date of birth
  final _doe = TextEditingController(); // date of doc expiry
  final _doc = TextEditingController(); // date of doc creation
  String? mycity = '';
  String? bloodType = '';
  final List<String> cities = algerianWilayas
      .map((city) => city['wilaya_name_ascii'].toString())
      .toList(); // city list
  final List<String> bloodtypes =
      bloodTypes.map((type) => type['bloodType'].toString()).toList();

  MrtdData? _mrtdData;

  final NfcProvider _nfc = NfcProvider();
  // ignore: unused_field
  late Timer _timerStateUpdater;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _initPlatformState();

    // Update platform state every 3 sec
    _timerStateUpdater = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      _initPlatformState();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    bool isNfcAvailable;
    try {
      NfcStatus status = await NfcProvider.nfcStatus;
      isNfcAvailable = status == NfcStatus.enabled;
    } on PlatformException {
      isNfcAvailable = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isNfcAvailable = isNfcAvailable;
    });
  }

  DateTime? _getDOBDate() {
    if (_dob.text.isEmpty) {
      return null;
    }
    return DateFormat.yMd().parse(_dob.text);
  }

  DateTime? _getDOEDate() {
    if (_doe.text.isEmpty) {
      return null;
    }
    return DateFormat.yMd().parse(_doe.text);
  }

  Future<String?> _pickDate(BuildContext context, DateTime firstDate,
      DateTime initDate, DateTime lastDate) async {
    final locale = Localizations.localeOf(context);
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: firstDate,
        initialDate: initDate,
        lastDate: lastDate,
        locale: locale);

    if (picked != null) {
      return DateFormat.yMd().format(picked);
    }
    return null;
  }

  void _readMRTD() async {
    try {
      setState(() {
        _mrtdData = null;
        _alertMessage = "Waiting for document tag ...";
        _isReading = true;
      });

      await _nfc.connect(
          iosAlertMessage: "Hold your phone near Biometric document...");
      final passport = Passport(_nfc);

      setState(() {
        _alertMessage = "Reading document ...";
      });

      _nfc.setIosAlertMessage("Trying to read EF.CardAccess ...");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Trying to read EF.CardAccess ...",
              style: TextStyle(
                color: Colors.black,
              ),
            )),
          ),
          duration: Duration(seconds: 1), // Adjust the duration as needed
        ),
      );
      final mrtdData = MrtdData();

      try {
        mrtdData.cardAccess = await passport.readEfCardAccess();
      } on PassportError {
        //if (e.code != StatusWord.fileNotFound) rethrow;
      }

      _nfc.setIosAlertMessage("Trying to read EF.CardSecurity ...");

      try {
        mrtdData.cardSecurity = await passport.readEfCardSecurity();
      } on PassportError {
        //if (e.code != StatusWord.fileNotFound) rethrow;
      }

      _nfc.setIosAlertMessage("Initiating session ...");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Initiating session ...",
              style: TextStyle(
                color: Colors.black,
              ),
            )),
          ),
          duration: Duration(seconds: 1), // Adjust the duration as needed
        ),
      );
      final bacKeySeed =
          DBAKeys(_docNumber.text, _getDOBDate()!, _getDOEDate()!);
      await passport.startSession(bacKeySeed);

      _nfc.setIosAlertMessage(formatProgressMsg("Reading EF.COM ...", 0));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              formatProgressMsg("Reading EF.COM ...", 0),
              style: const TextStyle(
                color: Colors.black,
              ),
            )),
          ),
          duration: const Duration(seconds: 1), // Adjust the duration as needed
        ),
      );
      mrtdData.com = await passport.readEfCOM();

      _nfc.setIosAlertMessage(formatProgressMsg("Reading Data Groups ...", 20));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              formatProgressMsg("Reading Data Groups ...", 20),
              style: const TextStyle(
                color: Colors.black,
              ),
            )),
          ),
          duration: const Duration(seconds: 1), // Adjust the duration as needed
        ),
      );

      if (mrtdData.com!.dgTags.contains(EfDG1.TAG)) {
        mrtdData.dg1 = await passport.readEfDG1();
      }

      if (mrtdData.com!.dgTags.contains(EfDG2.TAG)) {
        mrtdData.dg2 = await passport.readEfDG2();
      }
      if (mrtdData.com!.dgTags.contains(EfDG15.TAG)) {
        mrtdData.dg15 = await passport.readEfDG15();
        _nfc.setIosAlertMessage(formatProgressMsg("Doing AA ...", 60));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                formatProgressMsg("Doing AA ...", 60),
                style: const TextStyle(
                  color: Colors.black,
                ),
              )),
            ),
            duration:
                const Duration(seconds: 1), // Adjust the duration as needed
          ),
        );

        mrtdData.aaSig = await passport.activeAuthenticate(Uint8List(8));
      }

      _nfc.setIosAlertMessage(formatProgressMsg("Reading EF.SOD ...", 80));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,

          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              formatProgressMsg("Reading EF.SOD ...", 80),
              style: const TextStyle(
                color: Colors.black,
              ),
            )),
          ),
          duration: const Duration(seconds: 1), // Adjust the duration as needed
        ),
      );
      mrtdData.sod = await passport.readEfSOD();
      setState(() {
        _mrtdData = mrtdData;
      });

      setState(() {
        _alertMessage = "";
      });

      _scrollController.animateTo(300.0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } on Exception catch (e) {
      final se = e.toString().toLowerCase();
      String alertMsg = "An error has occurred while reading document!";
      print(se);
      if (e is PassportError) {
        if (se.contains("security status not satisfied")) {
          alertMsg =
              "Failed to initiate session with document.\nCheck input data!";
        }
        _log.error("documentError: ${e.message}");
      } else {
        _log.error(
            "An exception was encountered while trying to read document: $e");
      }

      if (se.contains('timeout')) {
        alertMsg = "Timeout while waiting for document tag";
      } else if (se.contains("tag was lost")) {
        alertMsg = "Tag was lost. Please try again!";
      } else if (se.contains("invalidated by user")) {
        alertMsg = "";
      }

      setState(() {
        _alertMessage = alertMsg;
      });
    } finally {
      if (_alertMessage.isNotEmpty) {
        await _nfc.disconnect(iosErrorMessage: _alertMessage);
      } else {
        await _nfc.disconnect(
            iosAlertMessage: formatProgressMsg("Finished", 100));
      }
      setState(() {
        _isReading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Builder(builder: (BuildContext context) => _buildPage(context)));
  }

  bool _disabledInput() {
    return _isReading || !_isNfcAvailable;
  }

  List<Widget> _mrtdDataWidgets() {
    List<Widget> list = [];
    if (_mrtdData == null) return list;

    if (_mrtdData!.dg1 != null) {
      list.add(
        MakeMrtdDataWidget(
            header: 'personal details',
            mrz: _mrtdData!.dg1!.mrz,
            date_of_creation: _doc.text,
            longNumber: _doclongNumber.text,
            wilaya: mycity.toString(),
            bloodType: bloodType.toString(),
            pob: _pob.text,
            image: _mrtdData!.dg2!.imageData as Uint8List),
      );
    }
    return list;
  }

  Scaffold _buildPage(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  Row(children: <Widget>[
                    const Text('NFC available:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text(_isNfcAvailable ? "Yes" : "No",
                        style: const TextStyle(fontSize: 18.0))
                  ]),
                  const SizedBox(height: 40),
                  _buildForm(context),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed:
                        _disabledInput() || !_mrzData.currentState!.validate()
                            ? null
                            : _readMRTD,
                    child: Text(_isReading ? 'Reading ...' : 'Read document'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(_isNfcAvailable ? "" : "Activate your NFC",
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  _isReading
                      ? const SizedBox(
                          height: 100,
                          width: 100,
                          child: RiveAnimation.asset('assets/cardswipe.riv'))
                      : const SizedBox(),
                  Text(_alertMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_mrtdData != null ? "Document data:" : "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8.0, bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _mrtdDataWidgets(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Padding _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
      child: Form(
        key: _mrzData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              enabled: !_disabledInput(),
              controller: _docNumber,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'document number',
                  fillColor: Colors.white),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]+')),
                LengthLimitingTextInputFormatter(14)
              ],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter document number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              enabled: !_disabledInput(),
              controller: _doclongNumber,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'National identification number',
                  fillColor: Colors.white),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]+')),
                LengthLimitingTextInputFormatter(25)
              ],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter National identification number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? selectedCity) {
                mycity = selectedCity;
              },
              decoration: InputDecoration(
                enabled: !_disabledInput(),
                border: OutlineInputBorder(),
                labelText: 'City',
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your place of issue';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
                enabled: !_disabledInput(),
                controller: _dob,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of Birth',
                    fillColor: Colors.white),
                autofocus: false,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Please select Date of Birth';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final now = DateTime.now();
                  final firstDate = DateTime(now.year - 90, now.month, now.day);
                  final lastDate = DateTime(now.year - 15, now.month, now.day);
                  final initDate = _getDOBDate();
                  final date = await _pickDate(
                      context, firstDate, initDate ?? lastDate, lastDate);
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (date != null) {
                    _dob.text = date;
                  }
                }),
            const SizedBox(height: 12),
            TextFormField(
                enabled: !_disabledInput(),
                controller: _doc,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of creation',
                    fillColor: Colors.white),
                autofocus: false,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Please select Date of creation';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final now = DateTime.now();
                  final firstDate =
                      DateTime(now.year - 20, now.month, now.day + 1);
                  final lastDate = DateTime(now.year, now.month + 6, now.day);
                  final initDate = _getDOEDate();
                  final date = await _pickDate(
                      context, firstDate, initDate ?? firstDate, lastDate);

                  FocusScope.of(context).requestFocus(FocusNode());
                  if (date != null) {
                    _doc.text = date;
                  }
                }),
            const SizedBox(height: 12),
            TextFormField(
                enabled: !_disabledInput(),
                controller: _doe,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of Expiry',
                    fillColor: Colors.white),
                autofocus: false,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Please select Date of Expiry';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // Can pick date from tomorrow and up to 10 years
                  final now = DateTime.now();
                  final firstDate = DateTime(now.year, now.month, now.day + 1);
                  final lastDate =
                      DateTime(now.year + 10, now.month + 6, now.day);
                  final initDate = _getDOEDate();
                  final date = await _pickDate(
                      context, firstDate, initDate ?? firstDate, lastDate);

                  FocusScope.of(context).requestFocus(FocusNode());
                  if (date != null) {
                    _doe.text = date;
                  }
                }),
            const SizedBox(height: 12),
            TextFormField(
              enabled: !_disabledInput(),
              controller: _pob,
              decoration: InputDecoration(
                  enabled: !_disabledInput(),
                  border: OutlineInputBorder(),
                  labelText: 'place of birth',
                  fillColor: Colors.white),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return 'Please enter your place of birth';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              items: bloodtypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? selected) {
                bloodType = selected;
              },
              decoration: InputDecoration(
                enabled: !_disabledInput(),
                border: OutlineInputBorder(),
                labelText: 'Blood Type',
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your Blood Type';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
