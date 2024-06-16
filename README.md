> [!IMPORTANT]
> Created by [Preternatural AI](https://preternatural.ai/), an exhaustive client-side AI infrastructure for Swift.<br/>
> This project and the frameworks used are presently in alpha stage of development.

# Voice Recorder: Transcribe your voice recordings with Whisper.

Tailored for active professionals and students, VoiceRecorder demonstrates how to transform the way customers capture and organize audio. Traditional voice recorders often leave customers with endless ambiguously named files like “New Recording,” differentiated only by their recording dates. This makes retrieving specific recordings cumbersome, especially when managing multiple files from lectures, meetings, or other important sessions. 

VoiceRecorder demonstrates how to enhance the recording experience by not only capturing audio but also offering intelligent transcription and analysis. Upon creating a recording, VoicePilot utilizes OpenAI’s Whisper API to deliver precise transcriptions, complete with timestamped segments for easy navigation. Moreover, it automatically generates a descriptive name, a concise summary, and highlights the key points for each recording, streamlining the customer’s review process and making information retrieval straightforward.

VoicePilot exemplifies how integrating Whisper and LLMs with Voice can streamline the management of multiple recordings from lectures or meetings, making it easier to access and retrieve specific segments. Technically, the project helps understand how to work with OpenAI’s Whisper API and the post-processing of transcription data in real-world applications using function calling. 
<br/><br/>
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/PreternaturalAI/AI/blob/main/LICENSE)

## Table of Contents
- [Usage](#usage)
- [Key Concepts](#key-concepts)
- [Preternatural Frameworks](#preternatural-frameworks)
- [Technical Specifications](#technical-specifications)
  - [Whisper Audio Trancription](#whisper-audio-trancription)
  - [Post-Processing the Transcription w/ Function Calling](#post-processing-the-transcription-w-function-calling)
- [Acknowledgements](#acknowledgements)
- [License](#license)

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

## Key Concepts

The Voice Recorder app is developed to demonstrate the the following key concepts:
- How to work with OpenAI’s Whisper API to get a transcription of the recording
- How to post-process the transcription using function calling to get structured data about the transcription

## Preternatural Frameworks
The following Preternatural Frameworks were used in this project: 
- [AI](https://github.com/PreternaturalAI/AI): The definitive, open-source Swift framework for interfacing with generative AI.
- [Media](https://github.com/vmanot/Media): Media makes it stupid simple to work with media capture & playback in Swift.

## Technical Specifications
Once the user records audio in the Voice Recorder app, the audio is transcribed via OpenAI's Whisper API and that audio text transcription is then further analyzed by an LLM to provide a title, summary, and key points of the text in a structured way via function calling. Here is the breakdown of these two steps:

### Whisper Audio Trancription 
[Whisper](https://openai.com/index/whisper/), created and open-sourced by OpenAI, is an Automatic Speech Recognition (ASR) system trained on 680,000 hours of audio content collected from the web. This makes Whisper particularly impressive at transcribing audio with background noise and varying accents compared to its predecessors. Another notable feature is its ability to transcribe audio with correct sentence punctuation. Integrating Whisper in your app with [Preternatural's AI framework](https://github.com/PreternaturalAI/AI) requires only the audio file and a few settings as needed: 

```swift
// TranscriptionCreationManager
import OpenAI
import Media

// The Whisper request is done via OpenAI
let client = OpenAI.Client(apiKey: "YOUR_API_KEY")

// only the audio file URL is needed
// to make sure your file is compatible with the Whisper API,
// you can use the Media framework to convert the file to other formats easily
let file: URL = try await MediaAssetLocation.url(url).convert(to: .wav)
                
let transcription = try await client.createTranscription(
    // file url
    audioFile: file,
    // a prompt can provide spellings of unique topic-specific words in the transcription
    prompt: nil,
    // provides timestamps on the audio
    timestampGranularities: [.segment],
    // required format when timestamp granularities are specified
    responseFormat: .verboseJSON 
)

let fullTranscription = transcription.text
let language = transcription.language
let duration = transcription.duration

// OpenAI.AudioTranscription.TranscriptionSegment
// includes start time, end time, and text for the segment
let segements = transcription.segments
```

That's it! You can see the full implementation in `TranscriptionCreationManager`. 

### Post-Processing the Transcription w/ Function Calling
The term "Function Calling" in the context of LLMs can be very confusing since no functions actually get called. At a high level, you can think of Function Calling as a way to return a structured JSON response via the Completion API. 

Now that we have the text transcription of the audio via OpenAI's Whisper API, we use function calling to get a structured analysis of the text. This is done in a few steps: 

1. Imagine a function. This sounds a bit weird, but the original purpose of function calling was to parse user's natural language input into function parameters. As the LLM is trained more on web application code, we need to imagine a web application function with the parameters that we want as the output. In this case, we want the LLM to analyze the transcription and create a title, summary and a list of key points.

```swift
    // imaginary function that doesn't exist in our app
    // note: since the LLM is trained better on web apps
    // we use web-based terminology
    // and snake case instead of the Swift-preffered camel case
    func add_recording_analysis_to_db(
        title: String,
        summary: String,
        keypoints: [String]
    ) async ->  Bool {
        // Make API call to your server to add the transcription title, summary, and keypoints to the database
        // recieve back true / false response from the API to confirm the reservation
        return reservationConfirmed
    }
```

2. Create the `Codable` results object to use in your app based on the LLM's function calling result based on the function parameters:

```swift
// TranscriptionAnalysisPromptManager

struct AddRecordingResult: Codable, Hashable, Sendable {
    struct RecordingAnalysis: Codable, Hashable, Sendable {
        var title: String
        var summary: String
        var keypoints: [String]
    }
    
    var recordingAnalysis: RecordingAnalysis
}
```

3. Create a `JSONSchema` of the LLM output. In other words, since we want the LLM to return back the transcription analysis results in structured JSON formatting, we need to provide it with the exact JSON structure that we expect - that we can easily decode and use as an object directly in our app.

```swift
// TranscriptionAnalysisPromptManager

// using the CorePersistence framework, which comes with the AI Package to create the JSONSchema
import CorePersistence

private var recordingTransliterationObjectSchema: JSONSchema { JSONSchema(
    type: .object,
    description: "The analysis of an audio transcription",
    properties: [
        "title" : JSONSchema(type: .string,
                             description: "A short Title describing the recording"),
        "summary" : JSONSchema(type: .string,
                               description: "A short one-sentence Summary about the recording"),
        "keypoints" : JSONSchema(type: .array,
                                  description: "A List of up to 5 most important points from the recording",
                                  items: .string)
    ],
    required: true // each property is required
)}
```
4. Create the function definition:
```swift
var addRecordingAnalysisFunction: AbstractLLM.ChatFunctionDefinition { AbstractLLM.ChatFunctionDefinition(
    name: "add_recording_analysis_to_db",
    context: "Add the title, summary, and five important points from this transcription of an audio recording.",
    parameters: JSONSchema(
        type: .object,
        description: "A Recording Analysis of the Audio Transcription",
        properties: [
            "recording_analysis": recordingTransliterationObjectSchema
        ]))
}
```
5. Now we use the normal completion API to make the function call.
The first step is to specify the System Prompt:
```swift
// TranscriptionAnalysisPromptManager

// The System Prompt provides general instructions for the LLM model
var systemPrompt: String {
    """
    You are AudioTranscriptionProcessorGPT.
    
    The user will give you a transcribed text from an audio recording.
    Your job is to provide the following information about the recording:
    
    1. A short Title describing the recording
    2. A short one-sentence Summary about the recording
    3. A List of up to 5 most important points from the recording
    
    Use the `add_recording_analysis_to_db` function to the database.
    """
}
```
Next, specify the messages. Here, we use the [Few-Shot Prompting](https://docs.preternatural.ai/few-shot-prompting) technique to give the LLM a specific example of the function call's expected result. 

```swift
//TranscriptionAnalysisManager

let messages: [AbstractLLM.ChatMessage] = [
     // the system prompt
    .system(promptManager.systemPrompt),
    // sample transcription text used in the few-shot prompting technique
    .user(sampleRecordingObject.recordingText),
    // sample function call result, with the JSON for the example transcription provided
    // see the sample in TranscriptionAnalysisPromptManager
    .functionCall(
        of: promptManager.addRecordingAnalysisFunction,
        arguments: sampleRecordingObject.expectedResult),
    // this is the user's transcription
    .user(transcription)
]
```
Finally, we can do the completion call to get back the recording analysis object that we specified before: 

```swift
// TranscriptionAnalysisManager

let functionCall: AbstractLLM.ChatFunctionCall = try await client.complete(
    messages,
    functions: [promptManager.addRecordingAnalysisFunction],
    as: .functionCall
)

let recordingAnalysis = try functionCall.decode(TranscriptionAnalysisPromptManager.AddRecordingResult.self).recordingAnalysis
```

You can view the full implementation in `TranscriptionAnalysisManager`. 

### Conclusion
By leveraging OpenAI's Whisper API to convert audio into text transcriptions, developers can use the power of LLMs to further analyze and structure the transcribed text. This integration enables the extraction of meaningful insights such as titles, summaries, key points, and much more. The combination of accurate transcriptions and intelligent text analysis businesses can offer enriched user experiences, making audio content not just more searchable but also more actionable.

## Acknowledgements

DSWaveformImage
- **Link**: [https://github.com/dmrschmidt/DSWaveformImage](https://github.com/dmrschmidt/DSWaveformImage)
- **License**: [MIT License](https://github.com/dmrschmidt/DSWaveformImage/blob/main/LICENSE)
- **Authors**: Dennis Schmidt and DSWaveformImage contributors

## License

This package is licensed under the [MIT License](https://github.com/PreternaturalAI/AI/blob/main/LICENSE).
