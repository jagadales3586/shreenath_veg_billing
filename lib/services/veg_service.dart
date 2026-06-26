import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/veg_model.dart';

class VegService {
  static const String _key = "veg_list_data";

  // ================= GET =================
  static Future<List<VegModel>> getVegList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null || jsonString.isEmpty) {
      final defaultList = _defaultVegList();
      await saveVegList(defaultList);
      return defaultList;
    }

    final List list = jsonDecode(jsonString);
    return list.map((e) => VegModel.fromJson(e)).toList();
  }

  // ================= SAVE =================
  static Future<void> saveVegList(List<VegModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  // ================= DEFAULT DATA =================
  static List<VegModel> _defaultVegList() {
    return [
      VegModel(
        name: "बटाटा",
        rate: 20,
        category: "भाजी",
        unit: "Kg",
      ),
      VegModel(
        name: "कांदा",
        rate: 30,
        category: "भाजी",
        unit: "Kg",
      ),
      VegModel(
       name: "दोडका",
       rate: 40,
        category: "भाजी",
        unit: "Kg",
      ),
      VegModel(
        name: "फुलकोबी",
        rate: 40,
        category: "भाजी",
        unit: "नग",
      ),
      VegModel(
        name: "कोथिंबीर",
        rate: 10,
        category: "पालेभाजी",
        unit: "जुडी",
      ),

VegModel(
  name: "वांगी",
  rate: 30,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "लसूण",
  rate: 120,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "लिंबू",
  rate: 80,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "मिरची",
  rate: 60,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "आले",
  rate: 80,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "बीन्स",
  rate: 70,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "शिमला मिरची",
  rate: 50,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "गाजर नारिंगी",
  rate: 40,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "दुधीभोपळा",
  rate: 30,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "गवार",
  rate: 50,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "टोमॅटो गावरान",
  rate: 35,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "कोबी",
  rate: 20,
  category: "भाजी",
  unit: "Kg",
),
VegModel(
  name: "भेंडी",
  rate: 40,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "काकडी",
  rate: 25,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "कारले",
  rate: 50,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "काळा घेवडा",
  rate: 80,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "कारटुले",
  rate: 60,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "परवर",
  rate: 50,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "पडवळ",
  rate: 40,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "बाऊनरी",
  rate: 80,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "ओमेगा",
  rate: 80,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "तोंडली",
  rate: 60,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "मुळा",
  rate: 20,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "बीट",
  rate: 30,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "रताळे",
  rate: 40,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "सुरण",
  rate: 60,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "हिरवे वाटाणे",
  rate: 80,
  category: "भाजी",
  unit: "Kg",
),

VegModel(
  name: "मका",
  rate: 20,
  category: "भाजी",
  unit: "नग",
),
VegModel(
  name: "पालक",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "मेथी",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),



VegModel(
  name: "शेपू",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "चाकवत",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "माठ",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "तांदुळजा",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "अंबाडी",
  rate: 20,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "करडई",
  rate: 20,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "राजगिरा",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "मुळ्याचा पाला",
  rate: 15,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "कांद्याची पात",
  rate: 20,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "लसूण पात",
  rate: 20,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "पुदिना",
  rate: 10,
  category: "पालेभाजी",
  unit: "जुडी",
),

VegModel(
  name: "कढीपत्ता",
  rate: 10,
  category: "पालेभाजी",
  unit: "जुडी",
),

    VegModel(
  name: "टोमॅटो",
  rate: 25,
 category: "भाजी",
 unit: "Kg",
 ),
     
     VegModel(
   name: "कांदा गोणी",
   rate: 1200,
   category: "भाजी",
   unit: "गोणी",
  ),       
        
         
      VegModel(
  name: "सफरचंद",
  rate: 120,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "केळी",
  rate: 60,
  category: "फळे",
  unit: "डझन",
),

VegModel(
  name: "संत्री",
  rate: 80,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "मोसंबी",
  rate: 70,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "डाळिंब",
  rate: 150,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "द्राक्षे",
  rate: 100,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "पपई",
  rate: 40,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "पेरू",
  rate: 60,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "अननस",
  rate: 50,
  category: "फळे",
  unit: "नग",
),

VegModel(
  name: "कलिंगड",
  rate: 25,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "खरबूज",
  rate: 40,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "आंबा",
  rate: 120,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "चिकू",
  rate: 60,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "सीताफळ",
  rate: 80,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "जांभूळ",
  rate: 100,
  category: "फळे",
  unit: "Kg",
),
VegModel(
  name: "रामफळ",
  rate: 100,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "बोर",
  rate: 60,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "करवंद",
  rate: 120,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "ताडगोळा",
  rate: 20,
  category: "फळे",
  unit: "नग",
),

VegModel(
  name: "किवी",
  rate: 250,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "ड्रॅगन फ्रूट",
  rate: 180,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "स्ट्रॉबेरी",
  rate: 200,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "लिची",
  rate: 180,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "अंजीर",
  rate: 300,
  category: "फळे",
  unit: "Kg",
),

VegModel(
  name: "नारळ",
  rate: 40,
  category: "फळे",
  unit: "नग",
),

VegModel(

  name: "हरभरा",
  rate: 70,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "मूग",
  rate: 120,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "मटकी",
  rate: 110,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "उडीद",
  rate: 130,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "तूर",
  rate: 140,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "चवळी",
  rate: 100,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "वाटाणा",
  rate: 80,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "राजमा",
  rate: 140,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "सोयाबीन",
  rate: 60,
  category: "मोडधान्य",
  unit: "Kg",
),

VegModel(
  name: "मसूर",
  rate: 110,
  category: "मोडधान्य",
  unit: "Kg",
),
    ];
  }
}