const admin = require("firebase-admin/app");
admin.initializeApp();

const analyzeSignageContext = require("./analyze_signage_context.js");
exports.analyzeSignageContext = analyzeSignageContext.analyzeSignageContext;
const virtualTryOn = require("./virtual_try_on.js");
exports.virtualTryOn = virtualTryOn.virtualTryOn;
const sendTryOnEmail = require("./send_try_on_email.js");
exports.sendTryOnEmail = sendTryOnEmail.sendTryOnEmail;
