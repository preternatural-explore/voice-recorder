> [!IMPORTANT]
> Created by [Preternatural AI](https://preternatural.ai/), an exhaustive client-side AI infrastructure for Swift.<br/>
> This project and the frameworks used are presently in alpha stage of development.

# Voice Recorder: Transcribe your voice recordings with Whisper.

Tailored for active professionals and students, VoiceRecorder demonstrates how to transform the way customers capture and organize audio. Traditional voice recorders often leave customers with endless ambiguously named files like “New Recording,” differentiated only by their recording dates. This makes retrieving specific recordings cumbersome, especially when managing multiple files from lectures, meetings, or other important sessions. 

VoiceRecorder demonstrates how to enhance the recording experience by not only capturing audio but also offering intelligent transcription and analysis. Upon creating a recording, VoicePilot utilizes OpenAI’s Whisper API to deliver precise transcriptions, complete with timestamped segments for easy navigation. Moreover, it automatically generates a descriptive name, a concise summary, and highlights the key points for each recording, streamlining the customer’s review process and making information retrieval straightforward.

VoicePilot exemplifies how integrating Whisper and LLMs with Voice can streamline the management of multiple recordings from lectures or meetings, making it easier to access and retrieve specific segments. Technically, the project helps understand how to work with OpenAI’s Whisper API and the post-processing of transcription data in real-world applications using function calling. 
<br/><br/>
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/PreternaturalAI/AI/blob/main/LICENSE)

## Usage
#### Supported Platforms
<!-- macOS-->
<p align="left">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg">
  <img alt="macos" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg" height="24">
</picture>&nbsp;

<!--iPhone-->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios-active.svg">
  <img alt="ios" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios-active.svg" height="24">
</picture>&nbsp;

<!-- iPad-->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados-active.svg">
  <img alt="ipados" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados-active.svg" height="24">
</picture>&nbsp;

</p>

To install and run VoiceRecorder:

1. Download and open the project
2. Add your OpenAI API Key in the `AIClientManager` file:

```swift
// AIManagers/AIClientManager
static let client = OpenAI.Client(
    apiKey: "YOUR_API_KEY"
)
```

*You can get the OpenAI API key on the [OpenAI developer website](https://platform.openai.com/). Note that you have to set up billing and add a small amount of money for the API calls to work (this will cost you less than 1 dollar).* 

3. Run the project on the Mac, iPad, or iPhone
4. Click the record button to capture the recording - if you do not have anything to record right away, you can open a YouTube video on your phone and play it to the VoicePilot on the Mac or vice versa to the get the video transcription. 

Here is what it looks like when we recorded part of Alan Kay’s lecture [How to Invent the Future II - Stanford CS183F: Startup School](https://youtu.be/1e8VZlPBx_0?si=bg_mchxsLDxFb8Hz).

 <img width="1280" alt="voicemoc" src="https://github.com/preternatural-explore/VoicePilot/assets/1157147/c5542492-b86b-4358-966e-0edbb268f88d"><br />

## Table of Contents
- [Key Concepts](#key-concepts)
- [Preternatural Frameworks](#preternatural-frameworks)
- [Acknowledgements](#acknowledgements)
- [License](#license)

## Key Concepts

The Voice Recorder app is developed to demonstrate the the following key concepts:
- How to work with OpenAI’s Whisper API to get a transcription of the recording
- How to post-process the transcription using function calling to get structured data about the transcription

## Preternatural Frameworks
The following Preternatural Frameworks were used in this project: 
- [AI](https://github.com/PreternaturalAI/AI): The definitive, open-source Swift framework for interfacing with generative AI.
- [Media](https://github.com/vmanot/Media): Media makes it stupid simple to work with media capture & playback in Swift.

# Acknowledgements

DSWaveformImage
- **Link**: [https://github.com/dmrschmidt/DSWaveformImage](https://github.com/dmrschmidt/DSWaveformImage)
- **License**: [MIT License](https://github.com/dmrschmidt/DSWaveformImage/blob/main/LICENSE)
- **Authors**: Dennis Schmidt and DSWaveformImage contributors

# License

This package is licensed under the [MIT License](https://github.com/PreternaturalAI/AI/blob/main/LICENSE).
