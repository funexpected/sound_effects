# About Sound_Effects

***Sounds_effects*** - is a simple application that was written for setting voices from Google TTS and Azure Cognitive Service for **``Funexpected.math``**.

For settings you have to use native Godot Engine Audio Server and buses (Tab audio at the bottom of the engine).

The application only allows you to compare different sets of effects via voice_profiles and save voice_profile.

## How the app stores voice_profiles

Voice_profile is repsented by .json file, that consists of language codes, effects for the language and parameters for effects.

## Features of app
  * Reverberation is duplicated for buses from 'en' bus;
  
  * If a bus has its own reverb the app uses for the bus its reverb (not from 'en' bus)
  
  * Custom bus is for comparing and playes records using voice_profiles.