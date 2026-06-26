import '../services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../models/market_model.dart';
import '../models/market_item_model.dart';
import '../models/bill_item.dart';
import '../models/bill_history_model.dart';

import '../services/bill_history_service.dart';

import 'bill_history_page.dart';

import '../widgets/receipt_preview_wrapper.dart';
import '../widgets/bill_receipt_widget.dart';

import 'dart:typed_data';

class RateQtyPage extends StatefulWidget {
  final List<BillItem> items;
  final double pending;
  final DateTime date;
  final String customerName;

  const RateQtyPage({
    super.key,
    required this.items,
    required this.pending,
    required this.date,
    required this.customerName,
  });

  @override
  State<RateQtyPage> createState() =>
      _RateQtyPageState();
}

class _RateQtyPageState
    extends State<RateQtyPage> {

  late DateTime selectedDate;

  bool saving = false;

  final SpeechToText speech =
      SpeechToText();

  bool isListening = false;

  FocusNode? activeFocus;

  bool voiceTextMode = true;

  bool customKeyboardOn = false;

  bool useCustomKeyboard = false;

  final ScrollController listController =
      ScrollController();

 double keyboardWidth = 420;

double keyboardHeight = 220;

double keyboardTop = 300;

double keyboardLeft = 30;
  final GlobalKey _receiptKey =
      GlobalKey();

 double parseMarathiNumber(String text) {

  final map = {
    "एक": 1,
    "दोन": 2,
    "तीन": 3,
    "चार": 4,
    "पाच": 5,
    "सहा": 6,
    "सात": 7,
    "आठ": 8,
    "नऊ": 9,
    "दहा": 10,
  };

  text = text.trim().toLowerCase();
  text = text.replaceAll("-", "");
  text = text.replaceAll(" ", "");

  if (map.containsKey(text)) {
    return map[text]!.toDouble();
  }

  if (text.startsWith(".")) {
    text = "0$text";
  }

  return double.tryParse(text) ?? 0;
}

Future<void> saveKeyboardHeight() async {

  final prefs =
      await SharedPreferences.getInstance();

   await prefs.setDouble(
  'keyboardWidth',
  keyboardWidth,
);   

  await prefs.setDouble(
    'keyboardHeight',
    keyboardHeight,
  );

  await prefs.setDouble(
    'keyboardTop',
    keyboardTop,
  );

  await prefs.setDouble(
    'keyboardLeft',
    keyboardLeft,
  );
}

Future<void> loadKeyboardHeight() async {

  final prefs =
      await SharedPreferences.getInstance();

setState(() {

  keyboardWidth =
      prefs.getDouble(
        'keyboardWidth',
      ) ??
      320;

  keyboardHeight =
      prefs.getDouble(
        'keyboardHeight',
      ) ??
      220;

  keyboardTop =
      prefs.getDouble(
        'keyboardTop',
      ) ??
      300;

  keyboardLeft =
      prefs.getDouble(
        'keyboardLeft',
      ) ??
      30;
});
}

Future<void> startListening(
  TextEditingController controller,
) async {

  bool available =
      await speech.initialize(

    onStatus: (status) {
      print(status);
    },

    onError: (error) {
      print(error);
    },
  );

  if (!available) {
    return;
  }

  setState(() {
    isListening = true;
  });

  speech.listen(
    listenFor: const Duration(
      minutes: 10,
    ),

    pauseFor: const Duration(
      seconds: 30,
    ),

    partialResults: true,

    listenMode: ListenMode.dictation,

    localeId: "mr_IN",

    onResult: (result) {

      String spoken =
          result.recognizedWords;

 final Map<String, String> numberMap = {

 "शून्य": "0",
        "एक": "1",
        "दोन": "2",
        "तीन": "3",
        "चार": "4",
        "पाच": "5",
        "सहा": "6",
        "सात": "7",
        "आठ": "8",
        "नऊ": "9",
        "दहा": "10",

        "अकरा": "11",
        "बारा": "12",
        "तेरा": "13",
        "चौदा": "14",
        "पंधरा": "15",
        "सोळा": "16",
        "सतरा": "17",
        "अठरा": "18",
        "एकोणीस": "19",

  "वीस":"20",
  "एकवीस":"21",
  "बावीस":"22",
  "तेवीस":"23",
  "चोवीस":"24",
  "पंचवीस":"25",
  "सव्वीस":"26",
  "सत्तावीस":"27",
  "अठ्ठावीस":"28",
  "एकोणतीस":"29",

  "तीस":"30",
  "एकतीस":"31",
  "बत्तीस":"32",
  "तेहेतीस":"33",
  "चौतीस":"34",
  "पस्तीस":"35",
  "छत्तीस":"36",
  "सदतीस":"37",
  "अडतीस":"38",
  "एकोणचाळीस":"39",

  "चाळीस":"40",
  "पन्नास":"50",
  "साठ":"60",
  "सत्तर":"70",
  "ऐंशी":"80",
  "नव्वद":"90",
  "शंभर":"100",
};

if (voiceTextMode) {

  // NUM MODE

  numberMap.forEach((k, v) {
    spoken = spoken.replaceAll(k, v);
  });

  spoken = spoken.replaceAll(
    RegExp(r'[^0-9.+]'),
    '',
  );

} else {

  // TXT MODE

  spoken = spoken.trim();
}

if (spoken.contains("+")) {

  final regExp =
      RegExp(r'(\d+)\s*\+\s*(\d+)');

  final match =
      regExp.firstMatch(spoken);

  if (match != null) {

    final a =
        int.tryParse(match.group(1)!) ?? 0;

    final b =
        int.tryParse(match.group(2)!) ?? 0;

    spoken = (a + b).toString();
  }
}

TextEditingController? controller;

for (var item in widget.items) {

  if (item.rateFocus == activeFocus) {
    controller = item.rateCtrl;
  }

  if (item.qtyFocus == activeFocus) {
    controller = item.qtyCtrl;
  }
}

if (controller == null) return;

final selection =
    controller.selection;

final newText =
    controller.text.replaceRange(
  selection.start,
  selection.end,
  spoken,
);

controller.value =
    TextEditingValue(
  text: newText,
  selection:
      TextSelection.collapsed(
    offset:
        selection.start +
        spoken.length,
  ),
);

setState(() {});
  }
  );
}
@override
void initState() {
  super.initState();

  loadKeyboardHeight();

  print("ITEMS = ${widget.items.length}");

  for (final item in widget.items) {

    print(
      "RATE FOCUS = ${item.rateFocus.hashCode}",
    );

    print(
      "QTY FOCUS = ${item.qtyFocus.hashCode}",
    );

    item.rateFocus.addListener(() {

      if (!mounted) return;

      if (item.rateFocus.hasFocus) {

        print(
          "RATE GOT FOCUS = ${item.rateFocus.hashCode}",
        );

        setState(() {
          activeFocus = item.rateFocus;
        });
      }
    });

    item.qtyFocus.addListener(() {

      if (!mounted) return;

      if (item.qtyFocus.hasFocus) {

        print(
          "QTY GOT FOCUS = ${item.qtyFocus.hashCode}",
        );

        setState(() {
          activeFocus = item.qtyFocus;
        });
      }
    });
  }

  selectedDate = widget.date;

  //WidgetsBinding.instance.addPostFrameCallback((_) {

    //if (!mounted) return;

    //if (widget.items.isNotEmpty) {

    //  FocusScope.of(context)
     //     .requestFocus(
     //   widget.items.first.rateFocus,
     // );

     // setState(() {
       // activeFocus =
          //  widget.items.first.rateFocus;
     // });

    //  print("INITIAL FOCUS SET");
   // }
 // });
}
  // ================= TOTALS =================

  double get itemsTotal {

    double total = 0;

    for (final item in widget.items) {

      final rate =
    parseMarathiNumber(
      item.rateCtrl.text,
    );

final qty =
    parseMarathiNumber(
      item.qtyCtrl.text,
    );

      total += rate * qty;
    }

    return total;
  }

  double get pending => 0;

  double get grandTotal =>
    itemsTotal +
    widget.pending +
    pending;

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

   return WillPopScope(
  onWillPop: () async {
  print("RATE PAGE BACK PRESSED");

  if (customKeyboardOn) {
    setState(() {
      customKeyboardOn = false;
      activeFocus = null;
    });

    //FocusScope.of(context).unfocus();

    return false;
  }

  print("RATE PAGE POP TRUE");

  Navigator.pop(context, true);

  return false;
},

  child: Scaffold(

  appBar: AppBar(
  backgroundColor: Colors.green,

  title: const Text(
    "Rate / Weight",
  ),

  actions: [

   IconButton(
  tooltip: "Save",
  icon: const Icon(Icons.save),
  onPressed: () async {

  final save = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("बिल सेव्ह करायचे आहे का?"),
      content: const Text(
        "सेव्ह केल्यानंतर बदल जतन होतील.",
      ),
      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text("नाही"),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("होय"),
        ),

      ],
    ),
  );

 print("SAVE RESULT = $save");

if (save == true) {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("CALLING _onDone"),
    ),
  );

  await _onDone();
}
},
   ),
   

    PopupMenuButton<String>(
      icon: const Icon(Icons.share),

      onSelected: (v) async {

        if (v == "text") {
          await _shareBillText();
        }

        if (v == "whatsapp") {
          await _shareToWhatsApp();
        }

        if (v == "pdf") {
          await _sharePdf();
        }

        if (v == "print") {
          await _printPdf();
        }
      },

      itemBuilder: (_) => const [

        PopupMenuItem(
          value: "text",
          child: Text("Share Text"),
        ),

        PopupMenuItem(
          value: "whatsapp",
          child: Text("WhatsApp Share"),
        ),

        PopupMenuItem(
          value: "pdf",
          child: Text("Share PDF"),
        ),

        PopupMenuItem(
          value: "print",
          child: Text("Print"),
        ),
      ],
    ),

    IconButton(
      tooltip: "Receipt Preview",
      icon: const Icon(Icons.preview),
      onPressed: _openReceiptPreview,
    ),

    IconButton(
      tooltip: "PDF Preview",
      icon: const Icon(Icons.picture_as_pdf),
      onPressed: _openPdfPreview,
    ),

    IconButton(
      tooltip: "Keyboard",
      icon: Icon(
        useCustomKeyboard
            ? Icons.keyboard
            : Icons.phone_android,
      ),

   

      onPressed: () {

       setState(() {
  useCustomKeyboard = !useCustomKeyboard;
  customKeyboardOn = useCustomKeyboard;
});

        if (useCustomKeyboard) {

          SystemChannels.textInput.invokeMethod(
            'TextInput.hide',
          );

        } else {

     // if (activeFocus != null) {
 // FocusScope.of(context)
    // .requestFocus(activeFocus!);
//} 

  //        Future.delayed(
    //       const Duration(milliseconds: 100),
     //       () {
       //      SystemChannels.textInput.invokeMethod(
        //       'TextInput.show',
         //     );       
         //      },
        //  );
        }
      },
    ),

    const SizedBox(width: 8),

  ],
),  

        

  body: GestureDetector(

  behavior: HitTestBehavior.opaque,

onTap: () {
  debugPrint("BODY TAP");
},

    child: Stack(
        children: [

        Column(

  children: [

    if (!customKeyboardOn)
      _infoBar(),

    if (!customKeyboardOn)
      _header(),

    Expanded(
      child: _list(),
    ),
  ],
),
     if (useCustomKeyboard &&
    customKeyboardOn)
  Positioned(  
    top: keyboardTop,
    left: keyboardLeft,

    child: GestureDetector(

     onPanUpdate: (details) {

  keyboardLeft += details.delta.dx;
  keyboardTop += details.delta.dy;
},
onPanEnd: (_) async {

  setState(() {});

  await saveKeyboardHeight();
},

      child: RepaintBoundary(
        child: _floatingKeyboard(),
      ),
    ),
  ),
  
// ===== HIDDEN RECEIPT =====

          Positioned(

            left: -5000,
            top: -5000,

            child: Material(

              child: RepaintBoundary(

                key: _receiptKey,

                child: SizedBox(

                  width: 380,

                  child: BillReceiptWidget(

                    bill: _tempBill(),

                    showQr: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
}
  
 

Widget _floatingKeyboard() {
final buttonHeight =
    (keyboardHeight - 50) / 3;

final buttonWidth =
    (keyboardWidth - 40) / 6;

 return Container(

  width: keyboardWidth,

  height: keyboardHeight,
  clipBehavior: Clip.antiAlias,

decoration: BoxDecoration(
  color: Colors.grey.shade900,
 borderRadius: const BorderRadius.only(
  topLeft: Radius.circular(22),
  topRight: Radius.circular(22),
  bottomLeft: Radius.circular(22),
  bottomRight: Radius.circular(22),
  
),
),
 

    child: Column(

      children: [

    Container(
  height: 35,
  decoration: BoxDecoration(
    color: Colors.grey.shade900,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(22),
      topRight: Radius.circular(22),
    ),
  ),
  child: Row(

            children: [

              const SizedBox(width: 8),

              const Icon(
                Icons.open_with,
                color: Colors.white,
                size: 18,
              ),

              const SizedBox(width: 8),

              const Text(

                "Keyboard",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
const Spacer(),

GestureDetector(
  onPanUpdate: (d) {

    setState(() {

      keyboardWidth += d.delta.dx;
      keyboardHeight += d.delta.dy;

      if (keyboardWidth < 220) {
        keyboardWidth = 220;
      }

      if (keyboardHeight < 120) {
        keyboardHeight = 120;
      }
    });
  },

  onPanEnd: (_) async {
    await saveKeyboardHeight();
  },

  child: const Padding(
    padding: EdgeInsets.only(right: 8),
    child: Icon(
      Icons.open_in_full,
      color: Colors.white,
      size: 18,
    ),
  ),
),
              
            ],
          ),
        ),

Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 25,
    ),
    child: GridView.count(
      physics:
          const NeverScrollableScrollPhysics(),

      crossAxisCount: 6,

      children: [

  voiceTextMode ? "NUM" : "TXT",
"1",
"2",
"3",
"4",
"5",

customKeyboardOn
    ? "K-ON"
    : "K-OFF",

"6",
"7",
"8",
"9",
"Next",

"🎤",
".",
"⌫",
"0",

].map((e) {
return InkWell(

  
    onTap: ()async {
    

  if (activeFocus == null) return;

  TextEditingController? controller;

  for (final item in widget.items) {

    if (item.rateFocus == activeFocus) {
      controller = item.rateCtrl;
    }

    if (item.qtyFocus == activeFocus) {
      controller = item.qtyCtrl;
    }
  }

  if (controller == null) return;
print("ACTIVE FOCUS = $activeFocus");
print("CONTROLLER FOUND = ${controller != null}");
print("CONTROLLER TEXT = ${controller.text}");

  // BACKSPACE
  print("KEY = $e");

if (e == "⌫") {
  print("BACKSPACE PRESSED");

  if (controller.text.isNotEmpty) {

    controller.text = controller.text.substring(
      0,
      controller.text.length - 1,
    );

    controller.selection =
        TextSelection.fromPosition(
      TextPosition(
        offset: controller.text.length,
      ),
    );
  }

  return;
}

// NEXT
else if (e == "Next") {

  FocusNode? next;

  for (int i = 0; i < widget.items.length; i++) {

    if (widget.items[i].qtyFocus == activeFocus) {

      next = (i + 1 < widget.items.length)
          ? widget.items[i + 1].qtyFocus
          : widget.items.first.qtyFocus;

      break;
    }

    if (widget.items[i].rateFocus == activeFocus) {

      next = (i + 1 < widget.items.length)
          ? widget.items[i + 1].rateFocus
          : widget.items.first.rateFocus;

      break;
    }
  }

 if (next != null) {

  //FocusManager.instance.primaryFocus?.unfocus();

  await Future.delayed(
    const Duration(milliseconds: 20),
  );

  FocusScope.of(context)
      .requestFocus(next);

  setState(() {
    activeFocus = next;
  });

  await Future.delayed(
    const Duration(milliseconds: 50),
  );

  if (next.hasFocus) {
    print("NEXT FOCUS OK");
  } else {
    print("NEXT FOCUS FAIL");
  }

  for (final item in widget.items) {

    if (item.qtyFocus == next) {

      item.qtyCtrl.selection =
          TextSelection.collapsed(
        offset: item.qtyCtrl.text.length,
      );
    }

    if (item.rateFocus == next) {

      item.rateCtrl.selection =
          TextSelection.collapsed(
        offset: item.rateCtrl.text.length,
      );
    }
  }


    for (final item in widget.items) {

      if (item.qtyFocus == next) {

        item.qtyCtrl.selection =
            TextSelection.collapsed(
          offset:
              item.qtyCtrl.text.length,
        );
      }

      if (item.rateFocus == next) {

        item.rateCtrl.selection =
            TextSelection.collapsed(
          offset:
              item.rateCtrl.text.length,
        );
      }
    }
  }

  return;
}
// TXT / NUM
else if (
  e == "TXT" ||
  e == "NUM"
) {

  setState(() {
    voiceTextMode =
        !voiceTextMode;
  });

  return;
}

// MIC
else if (e == "🎤") {

  if (isListening) {

    await speech.stop();

    setState(() {
      isListening = false;
    });

  } else {

  if (activeFocus != null) {
  FocusScope.of(context)
      .requestFocus(activeFocus!);
}
    startListening(
      controller,
    );
  }

  return;
}

 // NORMAL KEY
else if (
    e != "🎤" &&
    e != "⌫" &&
    e != "Next" &&
    e != "TXT" &&
    e != "NUM" &&
    e != "K-ON" &&
    e != "K-OFF"
) {

  final selection =
      controller.selection;

  final newText =
      controller.text.replaceRange(
    selection.start,
    selection.end,
    e,
  );

  controller.value =
      TextEditingValue(
    text: newText,
    selection:
        TextSelection.collapsed(
      offset:
          selection.start +
          e.length,
    ),
  );
}

setState(() {});

}, 

  child: Container(
   width: buttonWidth,
    height: buttonHeight,
    margin:
        const EdgeInsets.all(2),

    decoration: BoxDecoration(

      color: e == "🎤"

    ? (isListening
        ? Colors.red
        : Colors.purple)

    : e == "TXT" || e == "NUM"

        ? (voiceTextMode
            ? Colors.green
            : Colors.orange)

        : Colors.yellow,

    borderRadius: BorderRadius.circular(
  buttonHeight * 0.15,
   ),
 ),
    child: Center(

   child: FittedBox(
  fit: BoxFit.scaleDown,
  child: Text(
    e,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: buttonWidth * 0.22,
    ),
  ),
),
    ),
  ),
);
}).toList(),
          ),
        ),
),
      ],
    )
  );
}
    
  // ================= INFO BAR =================

  Widget _infoBar() {

    return Container(

      padding:
          const EdgeInsets.all(12),

      color: Colors.green.shade50,

      child: Row(

        children: [

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  "ग्राहक : ${widget.customerName}",

                  style:
                      const TextStyle(

                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                GestureDetector(

                  onTap: _pickDate,

                  child: Text(

                    "दिनांक : ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

                    style:
                        const TextStyle(

                      fontSize: 16,

                      decoration:
                          TextDecoration
                              .underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Column(

            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [

              Text(

                "एकूण ₹ ${itemsTotal.toStringAsFixed(0)}",

                style:
                    const TextStyle(

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(

                "उधारी ₹ ${widget.pending.toStringAsFixed(0)}",

                style:
                    const TextStyle(

                  fontSize: 18,

                  fontWeight:
                      FontWeight.bold,

                  color: Colors.red,
                ),
              ),

              Text(

                "ग्रँड ₹ ${grandTotal.toStringAsFixed(0)}",

                style:
                    const TextStyle(

                  fontSize: 18,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {

    return Container(

      color: Colors.green.shade200,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),

      child: const Row(

        children: [

          Expanded(
            flex: 3,
            child: Text(
              "भाजी",
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              "दर",
              textAlign:
                  TextAlign.center,
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              "वजन",
              textAlign:
                  TextAlign.center,
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              "रक्कम",
              textAlign:
                  TextAlign.center,
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              "❌",
              textAlign:
                  TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ================= LIST =================
Widget _list() {

  return ListView.builder(
    controller: listController,
    itemCount: widget.items.length,

    itemBuilder: (_, i) {

      final item = widget.items[i];

      final rate =
          parseMarathiNumber(
        item.rateCtrl.text,
      );

      final qty =
          parseMarathiNumber(
        item.qtyCtrl.text,
      );

      final amount = rate * qty;

      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 3,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 3,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(2),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [

            /// NAME
            Expanded(
              flex: 3,
              child: Text(
                item.name,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 6),

            /// RATE
            Expanded(
              flex: 3,

              child: _box(
                controller:
                    item.rateCtrl,

                focus:
                    item.rateFocus,

                onSubmit: () {

                  FocusNode nextFocus =
                      (i + 1 <
                              widget.items.length)
                          ? widget.items[
                                  i + 1]
                              .rateFocus
                          : widget.items
                              .first
                              .rateFocus;

                  FocusScope.of(context)
                      .requestFocus(
                    nextFocus,
                  );

                  setState(() {
                    activeFocus =
                        nextFocus;

                    customKeyboardOn =
                        true;
                  });

                  for (final item
                      in widget.items) {

                    if (item.rateFocus ==
                        nextFocus) {

                      item.rateCtrl
                              .selection =
                          TextSelection
                              .collapsed(
                        offset: item
                            .rateCtrl
                            .text
                            .length,
                      );

                      break;
                    }
                  }
                },
              ),
            ),

            const SizedBox(width: 6),

            /// QTY
            Expanded(
              flex: 5,

              child: _qtyBox(
                item,
                i,
              ),
            ),

            const SizedBox(width: 6),

            /// AMOUNT
            Expanded(
              flex: 3,

              child: Text(
                '₹${amount.toStringAsFixed(1)}',

                textAlign:
                    TextAlign.center,

                style:
                    TextStyle(
                  fontWeight:
                      FontWeight.w800,
                  fontSize: 20,

                  color: amount > 0
                      ? const Color
                          .fromARGB(
                          255,
                          226,
                          23,
                          229,
                        )
                      : const Color
                          .fromARGB(
                          255,
                          5,
                          129,
                          79,
                        ),
                ),
              ),
            ),

            /// DELETE
            Expanded(
              flex: 1,

              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),

                onPressed: () {

                  FocusScope.of(
                          context)
                      .unfocus();

                  setState(() {

                    widget.items
                        .removeAt(i);
                  });
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

 // ================= RATE BOX =================

Widget _box({
  required TextEditingController controller,
  required FocusNode focus,
  required VoidCallback onSubmit,
}) {

  return SizedBox(
    height: 42,

    child: TextField(
      controller: controller,
      focusNode: focus,

      readOnly: false,
      showCursor: true,

      keyboardType:
          const TextInputType.numberWithOptions(
        decimal: true,
      ),

      textInputAction:
          TextInputAction.next,

      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),

      onTap: () {

       focus.requestFocus();

        controller.selection =
            TextSelection.collapsed(
          offset: controller.text.length,
        );

        setState(() {
          activeFocus = focus;
          customKeyboardOn = true;
        });
      },

      onSubmitted: (_) {
        onSubmit();
      },

      onChanged: (_) {
        setState(() {});
      },

      textAlign: TextAlign.center,

      decoration: InputDecoration(
        hintText: "0",

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: 3,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),

          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),

          borderSide:
              const BorderSide(
            color: Colors.blue,
            width: 3,
          ),
        ),
      ),
    ),
  );
}
    
/// ================= वजन + UNIT =================///

Widget _qtyBox(
  BillItem item,
  int i,
) {
  return Container(
    height: 42,

    padding: const EdgeInsets.symmetric(
      horizontal: 2,
    ),

   decoration: BoxDecoration(
  color: activeFocus == item.qtyFocus
      ? Colors.blue.withOpacity(0.10)
      : Colors.white,

  borderRadius: BorderRadius.circular(10),

  border: Border.all(
    color: activeFocus == item.qtyFocus
        ? Colors.blue
        : Colors.grey.shade400,
    width: activeFocus == item.qtyFocus
        ? 3
        : 1.5,
  ),
),

    child: Row(
      children: [

        /// QTY
        Expanded(
          flex: 5,

          child: TextField(
            controller: item.qtyCtrl,
            focusNode: item.qtyFocus,

            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),

            onTap: () {

               print("QTY TAP");

              item.qtyFocus.requestFocus();

              item.qtyCtrl.selection =
                  TextSelection.collapsed(
                offset:
                    item.qtyCtrl.text.length,
              );

              setState(() {
                activeFocus = item.qtyFocus;
                customKeyboardOn = true;
              });
            },

            onChanged: (_) {
              setState(() {});
            },

            onSubmitted: (_) {

              final nextItem =
                  (i + 1 < widget.items.length)
                      ? widget.items[i + 1]
                      : widget.items.first;

              FocusScope.of(context)
                  .requestFocus(
                nextItem.qtyFocus,
              );

              nextItem.qtyCtrl.selection =
                  TextSelection.collapsed(
                offset:
                    nextItem.qtyCtrl.text.length,
              );

              setState(() {
                activeFocus =
                    nextItem.qtyFocus;
              });
            },

            decoration:
                const InputDecoration(
              border: InputBorder.none,
              enabledBorder:
                  InputBorder.none,
              focusedBorder:
                  InputBorder.none,

                filled: false,  
              isDense: true,
              contentPadding:
                  EdgeInsets.zero,
            ),
          ),
        ),

        /// DIVIDER
        Container(
          width: 0.7,
          height: 22,
          color: Colors.grey,
        ),

        const SizedBox(width: 2),

        /// UNIT
      SizedBox(
  width: 32,

  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      iconSize: 0,
      isExpanded: true,

      value: item.unit,

      selectedItemBuilder: (context) {
        return BillItem.units.map((u) {
          return Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Text(
                u,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const Icon(
                Icons.arrow_drop_down,
                size: 10,
              ),
            ],
          );
        }).toList();
      },

      items: BillItem.units.map((u) {
        return DropdownMenuItem<String>(
          value: u,
          child: Text(u),
        );
      }).toList(),

      onChanged: (value) {
        if (value == null) return;

        setState(() {
          item.unit = value;
        });
      },
    ),
  ),
),
      ],
    ),
  );
} 

  // ================= SHARE TEXT =================

  Future<void> _shareBillText() async {

    await Share.share(
      _billText(),
    );
  }

  // ================= WHATSAPP =================

  Future<void> _shareToWhatsApp() async {

    final text =
        Uri.encodeComponent(
      _billText(),
    );

    final url = Uri.parse(
      "https://wa.me/?text=$text",
    );

    if (await canLaunchUrl(url)) {

      await launchUrl(
        url,
        mode:
            LaunchMode.externalApplication,
      );

    } else {

      await Share.share(
        _billText(),
      );
    }
  }

  // ================= IMAGE =================

  

  // ================= SHARE IMAGE =================

  

  // ================= PDF =================

  Future<Uint8List> _generatePdf() async {

  final bill = _tempBill();

  return await PdfService
      .generateBillPdf(bill);
}

// ================= SHARE PDF =================

Future<void> _sharePdf() async {

  final pdfBytes =
      await _generatePdf();

  await Printing.sharePdf(

    bytes: pdfBytes,

    filename:
        'bill_${DateTime.now().millisecondsSinceEpoch}.pdf',
  );
}
  // ================= PRINT =================

  Future<void> _printPdf() async {

    await Printing.layoutPdf(

    onLayout: (_) async {

      return await _generatePdf();
    },
  );
}

  // ================= TEXT =================

  String _billText() {

    final bill = _tempBill();

    String text = "";

    for (var item in bill.items) {

      text +=
          "${item['name']} ${item['qty']} ${item['unit']} = ₹${item['total']}\n";
    }

    return text;
  }

  // ================= SAVE =================

  Future<void> _onDone() async {

  print("SAVE CLICKED");

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("SAVE CLICKED"),
    ),
  );

  if (widget.items.isEmpty) {
    return;
  }

    setState(() {
      saving = true;
    });

    final bill =
        _tempBill();

    final market = MarketModel(

      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      shopName: "Walk-in",

      date: DateTime.now(),

      items: bill.items.map((e) {

        return MarketItemModel(

          name:
              e['name'] ?? '',

          rate:
              (e['rate'] ?? 0)
                  .toDouble(),

          qty:
              (e['qty'] ?? 0)
                  .toDouble(),

          extra: 0,

          unit:
              e['unit'] ?? '',
        );

      }).toList(),

      total:
          bill.total.toDouble(),
    );

  await BillHistoryService.saveBill(
  bill,
);
final bills =
    await BillHistoryService.getAllBills();

print("TOTAL BILLS = ${bills.length}");

setState(() {
  saving = false;
});

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text("बिल सेव्ह झाले"),
  ),
);
//FocusScope.of(context).unfocus();

setState(() {
  customKeyboardOn = false;
  useCustomKeyboard = false;
  activeFocus = null;
});

if (mounted) {

 // FocusManager.instance.primaryFocus?.unfocus();

  setState(() {
    customKeyboardOn = false;
    useCustomKeyboard = false;
    activeFocus = null;
  });

  await Future.delayed(
    const Duration(milliseconds: 300),
  );

  Navigator.pop(context, true);
}

  }

  // ================= DATE =================

  Future<void> _pickDate() async {

    final d =
        await showDatePicker(

      context: context,

      initialDate:
          selectedDate,

      firstDate:
          DateTime(2023),

      lastDate:
          DateTime(2030),
    );

    if (d != null) {

      setState(() {

        selectedDate = d;
      });
    }
  }

  // ================= PREVIEW =================

  void _openReceiptPreview() {

    FocusScope.of(context)
        .unfocus();

    final bill =
        _tempBill();

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) =>
            ReceiptPreviewWrapper(

          bill: bill,

          showQr: true,
        ),
      ),
    );
  }

  // ================= PDF PREVIEW =================

  void _openPdfPreview() {

    FocusScope.of(context)
        .unfocus();

    final bill =
        _tempBill();

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) =>
            ReceiptPreviewWrapper(

          bill: bill,

          showQr: true,

          autoOpenPdf: true,
        ),
      ),
    );
  }

  // ================= TEMP BILL =================

  BillHistoryModel _tempBill() {

    final now =
        DateTime.now();

    final items =
        widget.items.map((e) {

     final rate =
    parseMarathiNumber(
      e.rateCtrl.text,
    );

final qty =
    parseMarathiNumber(
      e.qtyCtrl.text,
    );
      final total =
          rate * qty;

      return {

  "name": e.name,

  "rate": rate,
  "rateText": e.rateCtrl.text,

  "qty": qty,
  "qtyText": e.qtyCtrl.text,

  "unit": e.unit,

  "total": total,

      };

    }).toList();

    final total =
        items.fold<double>(
      0,
      (s, e) =>
          s +
          ((e['total'] as num)
              .toDouble()),
    );

   return BillHistoryModel(

  billNo: now.millisecondsSinceEpoch,

  customerName: widget.customerName,

  date:
      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

  items: items,

  total: total,

  pending: widget.pending,

  grandTotal:
      total + widget.pending,

      tip: "",

  isPaid:
      (total + widget.pending) <= 0,

  createdAt:
      now.millisecondsSinceEpoch,
);
  }
//@override
//void dispose() {

 // FocusManager.instance.primaryFocus?.unfocus();

 // customKeyboardOn = false;
  //useCustomKeyboard = false;
  //activeFocus = null;

 // SystemChannels.textInput.invokeMethod(
   // 'TextInput.show',
  //);

 // speech.stop();

 // listController.dispose();

  //super.dispose();
//}
    }