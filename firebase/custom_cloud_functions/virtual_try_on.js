const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { GoogleGenAI } = require("@google/genai");

if (!admin.apps.length) admin.initializeApp();

const GOOGLE_API_KEY = functions.config().google.genai_key;
const ai = new GoogleGenAI({ apiKey: GOOGLE_API_KEY });
const GENERATION_MODEL = "gemini-3-pro-image-preview";

exports.virtualTryOn = functions
  .region("us-central1")
  .runWith({
    memory: "1GB",
    timeoutSeconds: 300,
  })
  .https.onCall(async (data, context) => {
    const { userImage, productImage, productDesc, category, signId } = data;
    const startTime = Date.now();

    try {
      // 1. AI Generation
      const result = await ai.models.generateContent({
        model: GENERATION_MODEL,
        contents: [
          {
            parts: [
              {
                text: `TASK: Inpainting-insert ${productDesc} on user. Keep face/background identical.`,
              },
              { inlineData: { data: userImage, mimeType: "image/png" } },
              { inlineData: { data: productImage, mimeType: "image/png" } },
            ],
          },
        ],
        config: {
          responseModalities: ["IMAGE"],
          thinkingConfig: { thinkingLevel: "low" },
        },
      });

      let tryOnBase64 = result.candidates?.[0]?.content?.parts?.find(
        (p) => p.inlineData,
      )?.inlineData?.data;
      if (!tryOnBase64) throw new Error("AI failed to return image.");

      // 2. Upload to the specific 'lumen-tryon' bucket
      const bucket = admin.storage().bucket("lumen-tryon");
      const filename = `shares/${signId}_${Date.now()}.png`;
      const file = bucket.file(filename);

      const buffer = Buffer.from(tryOnBase64, "base64");
      await file.save(buffer, {
        metadata: { contentType: "image/png" },
        public: false,
      });

      // 3. Generate Signed URL (Expires in 7 days)
      const [signedUrl] = await file.getSignedUrl({
        action: "read",
        expires: Date.now() + 7 * 24 * 60 * 60 * 1000,
      });

      // 4. Log Interaction
      await admin.firestore().collection("sign_logs").add({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        sign_id: signId,
        interaction_type: "try_on_completed",
        share_url: signedUrl,
        category: category,
      });

      return {
        success: true,
        try_on_image: tryOnBase64,
        share_url: signedUrl,
      };
    } catch (err) {
      console.error("TRY_ON_FAIL:", err.message);
      return { success: false, error: err.message };
    }
  });
