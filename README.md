# Project Lumen: The Audience of One 🚀

**Bridging the gap between physical and digital environments with the smartest digital sign ever built.**

Project Lumen is a privacy-first, adaptive digital signage engine built for the **Gemini 3 Global Hackathon**. It transforms static physical spaces into intelligent, responsive environments that serve an **Audience of One**.

---

## 📺 Project Demos
> [!IMPORTANT]
> Check out how Lumen is redefining the physical space through these demos.

* **Final Demo Video:** [Link to YouTube Video]
* **Technical Deep Dive:** [Link to Secondary Video/Walkthrough]

---

## 📖 The "Why"
Digital signage is everywhere, yet it is often invisible. Static loops talk to everyone, which means they talk to no one. For administrators, these systems are difficult to manage, expensive to update, and often rely on outdated, generic content. 

**Lumen changes the conversation.** By bridging the gap between physical context and digital intelligence, Lumen allows physical spaces to "see" and "reason." Whether it’s a family looking for a weekend activity or a commuter in need of a quick coffee, Lumen synthesizes the perfect message in real-time. We provide an **experience**, not a profile—personalizing the moment without ever compromising privacy.

---

## ⚡ Key Features
* **The Smartest Digital Sign:** Powered by **Gemini 3 Flash** to reason about physical surroundings—detecting group dynamics, styles, and context without identifying individuals.
* **Privacy-First by Design:** Ephemeral processing ensures no PII (Personally Identifiable Information) or images are ever stored. We see, we reason, we respond, and we forget.
* **Generative Product Placement:** Integrates with **Nano Banana Pro (Gemini 3 Pro Image)** to generate high-fidelity, bespoke visual assets that intelligently incorporate items from a pre-loaded product list.
* **Low Latency & Telemetry:** Features a high-frequency "Heartbeat" with granular performance tracking for Camera, Vision, and Generation splits.

---

## 🛠️ Tech Stack & Architecture
* **Frontend:** Flutter (Cross-platform iOS/Android/Web)
* **Brain:** Gemini 3 Flash (`gemini-3-flash-preview`)
* **Visuals:** Nano Banana Pro (`gemini-3-pro-image-preview`)
* **Backend:** Firebase Cloud Functions & Firestore
* **Security:** Firebase Environment Config & Secret Manager

### The "Heartbeat" & Telemetry Logic
Lumen utilizes a continuous asynchronous loop (`runLumenHeartbeat`) that manages the bridge between the physical lens and the digital display:

1.  **The Shutter (Lens Capture):** Triggers a 1x1 hidden camera widget. It captures the physical context and encodes it to Base64 while logging `cameraMs` latency.
2.  **Parallel AI Processing (The Brain):** The frame is sent to our Cloud Function along with venue-specific context (Safety Level, Venue Type, and Admin Settings). 
3.  **Multimodal Split-Reasoning:** * **Vision Task:** Gemini 3 Flash analyzes the audience (`duration_vision_ms`).
    * **Generation Task:** Nano Banana Pro synthesizes the ad asset (`duration_generation_ms`), selecting the most relevant item from the uploaded product catalog.
    * **Hardware Adaptation:** The generation logic respects admin-defined constraints, including screen aspect ratios and "Lightbox Mode"—which generates assets with alpha-transparency to seamlessly blend digital overlays with physical products inside the display.
4.  **The Swap (UI Render):** The UI performs a "Hot Swap" of the ad creative and updates the **Health Monitor** with real-time AI performance metrics.
5.  **Audit Trail:** Every cycle is logged to an anonymous Firestore Audit Trail, including the generated prompt and vision analysis for administrator review.

---

## 🚀 Getting Started

Lumen is ready for testing across all major platforms.

1.  **iOS:** Join our TestFlight for real-time hardware testing on Apple devices.
2.  **Android:** Download and install the latest APK directly for your Android hardware.
3.  **Web:** Use the public AI Studio link for an interactive, browser-based experience.

### 🔑 Local Environment Setup
To run the cloud functions locally, ensure your Firebase environment variables are configured:
```bash
firebase functions:config:set google.genai_key="YOUR_GEMINI_API_KEY"
