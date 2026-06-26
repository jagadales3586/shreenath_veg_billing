const admin = require("firebase-admin");

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const token = "fuhxofHpSoC_ZbOrPLb_2d:APA91bGX2-ISf_SAh1b7KSU9lkaKpvQAlqoF19V4FLYLsqBSbjM1ScVh6HVP5HqywvVafH951i-mt1j-98a6A4oZ4zYZG4SG_OYa9FfdZ-fuNRtk_CnhGFg";

admin.messaging().send({
  token: token,
  notification: {
    title: "🔔 नवीन ऑर्डर आली",
    body: "कृपया नवीन ऑर्डर तपासा",
  },
  android: {
    priority: "high",
    notification: {
      sound: "mixkit_doorbell_single_press_333",
      channelId: "orders_channel",
    },
  },
}).then(() => {
  console.log("Notification Sent");
}).catch((err) => {
  console.log(err);
});