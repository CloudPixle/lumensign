const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { GoogleGenAI } = require("@google/genai");

if (!admin.apps.length) admin.initializeApp();

const VISION_MODEL = "gemini-3-flash-preview";
const GENERATION_MODEL = "gemini-3-pro-image-preview";

exports.analyzeSignageContext = functions
  .region("us-central1")
  .runWith({
    memory: "1GB",
    timeoutSeconds: 120,
  })
  .https.onCall(async (data, context) => {
    // 1. ADMIN KILL SWITCH if needed
    try {
      const configDoc = await admin
        .firestore()
        .collection("admin_controls")
        .doc("vtrtBSNUy5FqKwsvvTMB")
        .get();
      if (configDoc.exists && configDoc.data().is_api_enabled === false) {
        throw new functions.https.HttpsError(
          "unavailable",
          "Service disabled.",
        );
      }
    } catch (err) {
      if (err instanceof functions.https.HttpsError) throw err;
    }

    const GOOGLE_API_KEY = functions.config().google.genai_key;
    const ai = new GoogleGenAI({ apiKey: GOOGLE_API_KEY });

    const {
      base64Image,
      venueType,
      safetyLevel,
      customContext,
      fallbackText,
      aspectRatio,
    } = data;
    if (!base64Image)
      return { person_detected: false, vision_analysis: "No Image" };

    const style =
      safetyLevel === "relaxed"
        ? "Modern, high-energy"
        : "Clean, bright, professional";
    const startTime = Date.now();

    try {
      // --- PHASE 1: VISION (FLASH) ---
      const visionStart = Date.now();
      const visionResponse = await ai.models.generateContent({
        model: VISION_MODEL,
        contents: [
          {
            parts: [
              {
                text: `Return JSON: {"person_detected": boolean, "scene_description": "string"}. Analyze the persona of people in this ${venueType}.`,
              },
              {
                inlineData: { data: base64Image, mimeType: "image/png" },
                mediaResolution: "LOW",
              },
            ],
          },
        ],
        config: {
          responseMimeType: "application/json",
          thinkingConfig: { thinkingLevel: "medium" },
        },
      });

      const visionJson = JSON.parse(visionResponse.text);
      const visionMs = Date.now() - visionStart;

      // LIGHTBOX LOGIC
      if (visionJson.person_detected === false) {
        return {
          person_detected: false,
          generated_image_base64: null,
          vision_analysis: "No audience detected.",
          duration_vision_ms: visionMs,
          duration_ai_ms: Date.now() - startTime,
        };
      }

      // --- PHASE 2: GENERATION (PRO) ---
      const genStart = Date.now();
      const productsSnapshot = await admin
        .firestore()
        .collection("products")
        .limit(5)
        .get();
      const productList = productsSnapshot.docs.map((doc) => ({
        label: doc.data().label,
        description: doc.data().description,
        base64: doc.data().image_base64,
      }));

      const generationPromptParts = [
        {
          text: `You are a creative director... AUDIENCE: ${visionJson.scene_description}. INSTRUCTIONS: ${customContext || "Premium."} TASK: Portrait ad for ${venueType} with text "${fallbackText}".`,
        },
      ];

      productList.forEach((prod) => {
        generationPromptParts.push({ text: `PRODUCT: ${prod.label}.` });
        generationPromptParts.push({
          inlineData: { data: prod.base64, mimeType: "image/png" },
        });
      });

      const generationResponse = await ai.models.generateContent({
        model: GENERATION_MODEL,
        contents: [{ parts: generationPromptParts }],
        config: {
          responseModalities: ["TEXT", "IMAGE"],
          imageConfig: {
            aspect_ratio: aspectRatio || "9:16",
            image_size: "2K",
          },
        },
      });

      const generationMs = Date.now() - genStart;
      let generatedBase64 = null;
      if (generationResponse.candidates?.[0]?.content?.parts) {
        for (const part of generationResponse.candidates[0].content.parts) {
          if (part.inlineData) generatedBase64 = part.inlineData.data;
        }
      }

      return {
        person_detected: true,
        generated_image_base64: generatedBase64,
        vision_analysis: visionJson.scene_description,
        ad_prompt: "Custom Ad Generated",
        duration_vision_ms: visionMs,
        duration_generation_ms: generationMs,
        duration_ai_ms: Date.now() - startTime,
      };
    } catch (err) {
      return {
        error: err.message,
        person_detected: false,
        duration_ai_ms: Date.now() - startTime,
      };
    }
  });
