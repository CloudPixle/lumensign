const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (!admin.apps.length) admin.initializeApp();

const fetch = require("node-fetch");

const SPARKPOST_API_KEY = functions.config().sparkpost?.key;
const SPARKPOST_BASE =
  functions.config().sparkpost?.baseurl || "https://api.sparkpost.com/api/v1";

exports.sendTryOnEmail = functions
  .region("us-central1")
  .runWith({ timeoutSeconds: 60, memory: "512MB" })
  .https.onCall(async (data, context) => {
    // UPDATED: Extract signId from incoming data
    const { recipientEmail, imageBase64, signId } = data;

    if (!recipientEmail || !imageBase64) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing recipientEmail or imageBase64.",
      );
    }

    try {
      const bucket = admin.storage().bucket();
      const filename = `tryon_results/${Date.now()}.png`;
      const file = bucket.file(filename);
      const base64Data = imageBase64.replace(/^data:image\/\w+;base64,/, "");
      const buffer = Buffer.from(base64Data, "base64");

      await file.save(buffer, {
        metadata: { contentType: "image/png" },
        public: true,
      });

      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${filename}`;

      const payload = {
        content: { template_id: "lumen-tryon-result-v1" },
        substitution_data: {
          year: new Date().getFullYear().toString(),
          tryon_image_url: publicUrl,
        },
        recipients: [{ address: { email: recipientEmail } }],
      };

      const response = await fetch(`${SPARKPOST_BASE}/transmissions`, {
        method: "POST",
        headers: {
          Authorization: SPARKPOST_API_KEY,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`SparkPost failed: ${errorText}`);
      }

      // UPDATED: Log uses dynamic signId from App State
      await admin
        .firestore()
        .collection("sign_logs")
        .add({
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          interaction_type: "email_sent",
          user_email: recipientEmail,
          status: "completed",
          sign_id: signId || "unknown_mirror",
          content_type: "lead_capture",
          analysis_text: "User shared look via email",
          duration_generation_ms: 0,
          duration_camera_ms: 0,
          duration_vision_ms: 0,
        });

      return { success: true };
    } catch (error) {
      console.error("Cloud Function Error:", error);
      throw new functions.https.HttpsError("internal", error.message);
    }
  });
