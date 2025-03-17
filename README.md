# Discover Palestine - AI Chat Guide 🍉

**Discover Palestine** is a Flutter-based AI-powered chat application designed to help users explore the rich heritage, culture, and history of Palestine. The app integrates **speech-to-text**, **text-to-speech**, and **AI-powered chat** functionalities to provide an interactive and engaging experience. Users can ask questions, upload images, and receive detailed responses about Palestinian landmarks, traditions, and more.

## Features

1. **AI-Powered Chat**:
   - Ask questions about Palestine and get detailed responses powered by ChatGPT.
   - Supports both text and voice input.

2. **Speech-to-Text**:
   - Speak your questions instead of typing.
   - Real-time transcription of spoken words.

3. **Text-to-Speech**:
   - Listen to the AI's responses with text-to-speech functionality.
   - Toggle TTS on/off based on preference.

4. **Image Upload**:
   - Upload images to get context or information about them.
   - Integrated with an object detection API.

5. **User-Friendly Interface**:
   - Beautifully designed chat bubbles with user and assistant avatars.
   - Background image for a cultural touch.

6. **Real-Time Interaction**:
   - Smooth scrolling and real-time updates for chat messages.
   - Block sending messages while waiting for a response to avoid spamming.

---

## Screenshots 



## Installation 

To run this project locally, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/masaabuaisheh/Discover-Palestine-.git
   cd Discover-Palestine
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

---

## Dependencies 

This project uses the following packages:

- `flutter_tts`: For text-to-speech functionality.
- `speech_to_text`: For speech-to-text transcription.
- `image_picker`: For uploading images from the gallery.
- `http`: For making API requests to ChatGPT and image upload services.
- `path_provider`: For handling temporary file storage.

---

## Configuration 

### API Keys
To use the ChatGPT and image upload services, you need to configure your API keys:

1. **ChatGPT API**:
   - Replace the `rapidApiKey` in `lib/openai_service.dart` with your RapidAPI key.
   - Update the `rapidApiHost` if necessary.

2. **Image Upload API**:
   - Replace the `copilotApiKey` in `lib/openai_service.dart` with your RapidAPI key.
   - Update the `copilotApiHost` if necessary.

---

## Usage 

1. **Ask Questions**:
   - Type or speak your questions about Palestine.
   - The AI will respond with detailed information.

2. **Upload Images**:
   - Tap the image icon to upload a photo.
   - The app will process the image and provide relevant information.

3. **Toggle TTS**:
   - Use the volume icon to enable/disable text-to-speech for AI responses.

4. **Scroll Through Chat**:
   - Scroll up to view previous messages.
   - The app bar changes color as you scroll.

---

## Contributing

Contributions are welcome! If you have suggestions, bug reports, or feature requests, please open an issue or submit a pull request.
