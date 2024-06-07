# VoicePilot: An AI-Powered Voice Recorder

Tailored for active professionals and students, VoicePilot demonstrates how to transform the way customers capture and organize audio. Traditional voice recorders often leave customers with endless ambiguously named files like “New Recording,” differentiated only by their recording dates. This makes retrieving specific recordings cumbersome, especially when managing multiple files from lectures, meetings, or other important sessions. 

VoicePilot demonstrates how to enhance the recording experience by not only capturing audio but also offering intelligent transcription and analysis. Upon creating a recording, VoicePilot utilizes OpenAI’s Whisper API to deliver precise transcriptions, complete with timestamped segments for easy navigation. Moreover, it automatically generates a descriptive name, a concise summary, and highlights the key points for each recording, streamlining the customer’s review process and making information retrieval straightforward.

VoicePilot exemplifies how integrating AI with Voice can streamline the management of multiple recordings from lectures or meetings, making it easier to access and retrieve specific segments. Technically, the project helps understand how to work with OpenAI’s Whisper API and the post-processing of transcription data in real-world applications using function calling. 

## Table of Contents
- [Running the App](#running-the-app)
- [Key Concepts](#key-concepts)

## Running the App

To run VoicePilot:

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

<img width="1280" alt="export71CB7BA5-9CFA-494A-8AA0-6BC3BE3B5B9E" src="https://github.com/preternatural-explore/VoicePilot/assets/1157147/bec2d0c1-7abe-4356-b5eb-4469de019ace"> <br />

## Key Concepts

- How to work with OpenAI’s Whisper API to get a transcription of the recording
- How to post-process the transcription using function calling to get structured data about the transcription
