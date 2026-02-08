# Flutter AI Integrations 🚀

<div align="center">
  <img src="https://i.postimg.cc/MHDBK8Ym/icon.jpg" alt="Project Icon" width="150"/>
</div>

<p align="center">
  <strong>An Ongoing Learning & Practice Project</strong>
  <br />
  This project documents my journey of exploring and implementing various Cloud-based AI models within a Flutter application.
</p>

<p align="center">
  <a href="#-tech-stack">Tech Stack</a> •
  <a href="#-current-features--status">Features</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-known-issues--challenges">Challenges</a> •
  <a href="#-future-plans">Future Plans</a> •
  <a href="#-getting-started">Getting Started</a>
</p>

---

## 🎯 Project Goal

This project serves as a hands-on learning exercise to understand and integrate various Artificial Intelligence (AI) capabilities into a Flutter application. The primary focus is on leveraging cloud-based AI services for tasks like:
- 🤖 **Conversational AI** (Chatbots)
- 📝 **Text Generation**
- 🌐 **Language Translation**
- 😊 **Sentiment Analysis**

The long-term vision is to expand this project to include **On-Device AI** models for offline functionality.

---

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **AI Services:**
    - **Google Gemini:** For robust conversational chat and multimodal (text + image) analysis.
    - **Hugging Face:** For accessing a wide range of open-source models for various NLP tasks.
- **Core Packages:**
    - `google_generative_ai`: To interact with the Gemini API.
    - `http`: For making API calls to the Hugging Face Inference API.
    - `flutter_dotenv`: To securely manage API keys.
    - `dash_chat_2`: For building a feature-rich chat UI.
    - `image_picker`: To allow users to select images from their device.
    - `flutter_launcher_icons`: To generate the application's launcher icon.

---

## ✨ Current Features & Status

This project is divided into two main sections, each exploring a different AI provider.

### 1. Google Gemini Integration (Fully Functional)

A feature-complete chat screen has been implemented using the Gemini API.

- **✅ Conversational Chat:** Users can have a real-time, text-based conversation with the `gemini-1.5-flash` model.
- **✅ Multimodal Analysis (Image-to-Text):** Users can upload an image from their gallery, and the Gemini Vision model will analyze it and respond to prompts.

### 2. Hugging Face Integration (Partially Functional)

A tab-based interface provides access to various open-source NLP models hosted on Hugging Face.

- **✅ Sentiment Analysis:** **Working!** Successfully analyzes the emotion of an English text (e.g., joy, sadness, anger) using the `j-hartmann/emotion-english-distilroberta-base` model.
- **✅ Language Translation:** **Partially Working!**
    - **✅ Bengali to English:** Successfully translates text using the `Helsinki-NLP/opus-mt-bn-en` model.
    - **❌ English to Bengali:** The `Helsinki-NLP/opus-mt-en-bn` model is currently unreliable and fails with a `404 Not Found` error.
- **❌ Text Generation:** **Not Working.** Attempts to use various models (`google/gemma-7b`, `openai-community/gpt2`, `microsoft/DialoGPT-medium`) have been unsuccessful, consistently returning a `404 Not Found` error on the same endpoint where other models work.

---

## 📸 Screenshots

| Home Screen                                                 | Gemini Chat (Text & Image)                                | Hugging Face Home                                           |
| ----------------------------------------------------------- | --------------------------------------------------------- | ----------------------------------------------------------- |
| ![Home](https://i.postimg.cc/1XP6QzD0/home.jpg)              | ![Gemini Chat](https://i.postimg.cc/0jxmsN7d/gmini-Ai2.jpg) | ![Hugging Face](https://i.postimg.cc/x8YH2dLN/chat-Screen-Hugging-FAce.jpg) |
| **Sentiment Analysis**                                      | **Translation**                                           |
| ![Sentiment](https://i.postimg.cc/Vv1M8NXb/emotions-Sentimental.jpg) | ![Translation](https://i.postimg.cc/rscWkp5W/Hugging-Face-Translations.jpg) |

---

## ⚠️ Known Issues & Challenges

This project has been a valuable lesson in the real-world complexities of working with public AI APIs.

1.  **Hugging Face Endpoint & Model Inconsistency:** The biggest challenge has been the unreliability of the Hugging Face Inference API. It is evident that **not all models are available on all endpoints**. A URL that works for one model returns a `404 Not Found` for another, making integration a process of trial and error.
2.  **Debugging Complex Issues:** The project involved extensive debugging to resolve `403 Forbidden` (API token permissions), `410 Gone` (deprecated URLs), and `404 Not Found` (model/endpoint mismatch) errors. It also highlighted the challenges of build caches (`flutter clean`, deleting `.gradle`) when updating environment variables.
3.  **Hugging Face Chat Implementation:** A dedicated chat feature using a Hugging Face model is on hold due to the instability and errors encountered with available conversational models.

---

## 🔮 Future Plans

- [ ] **Solve the Hugging Face Issues:**
    - [ ] Research and find a reliable, currently-hosted model for **Text Generation**.
    - [ ] Find a working and reliable model for **English-to-Bengali Translation**.
- [ ] **Explore On-Device AI:**
    - [ ] Integrate a TensorFlow Lite (`.tflite`) model using the `tflite_flutter` package for offline tasks like image classification.
- [ ] **Enhance UI/UX:**
    - [ ] Improve the user interface for a more polished and intuitive experience.
    - [ ] Add better loading and error state indicators.
- [ ] **Add More Features:**
    - [ ] Experiment with other AI tasks like Speech-to-Text and Text-to-Speech.


    