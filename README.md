# M1D1 — Polyphonic iOS Synthesizer

A two-oscillator, four-voice polyphonic synthesizer for iPad / iPhone, with morphable waveforms, unison detune, ADSR envelopes, a Korg-style low-pass filter, and MIDI output. Built in Swift on top of AudioKit as a coursework project at the University of York (MSc Audio & Music Technology, 2022).

## Demo

[![Watch the demo on YouTube](https://img.youtube.com/vi/UUcf01ecIkM/maxresdefault.jpg)](https://www.youtube.com/watch?v=UUcf01ecIkM)

## Features

- **Two oscillators**, layered into a single mix bus. Each oscillator is independently configurable.
- **Morphable waveforms** per oscillator: sine, triangle, square, sawtooth (via `MorphingOscillator`).
- **Unison detune**: 1, 2, 3 or 4 detuned voices per oscillator with hand-tuned cent offsets, for thickness without phase issues.
- **Polyphony**: up to 4 simultaneous notes via a touch-driven voice counter that allocates incoming key presses to free voices.
- **ADSR envelope** per voice, with attack / decay / sustain / release controlled by rotated UISliders.
- **Korg-style low-pass filter** on the master bus, with cutoff and resonance controls.
- **Octave shift** for both keyboard and the second oscillator (±2 octaves).
- **MIDI output** via AudioKit's `MIDI()` class — note-on/note-off events broadcast on channel 1, so the synth can drive external instruments alongside its internal engine.

## Architecture

The synth is built around three Swift classes plus the standard iOS UI scaffolding:

| File | Role |
| --- | --- |
| `Oscillators.swift` | A 4-voice oscillator unit. Wraps four `MorphingOscillator` instances feeding a `Mixer`, with shared waveform selection, unison detuning presets, per-voice amplitudes, and ADSR ramping via `$amplitude.ramp(...)`. |
| `Multitouch.swift` | A polyphonic wrapper that holds four `Oscillators` units and routes incoming note events to whichever voice is free, mixing them into a single output bus. |
| `ViewController.swift` | Owns two `Multitouch` instances (osc 1 + osc 2), feeds them into a master `Mixer`, runs the mix through a `KorgLowPassFilter`, and connects the output to AudioKit's `AudioEngine`. Hosts all UI bindings (waveform / voice / level buttons, keyboard, ADSR sliders, master volume, MIDI). |

```
[ Touch input ]
       ↓
[ ViewController ]
       ↓
  ┌──────────────┐         ┌──────────────┐
  │ Osc 1 (Multi)│         │ Osc 2 (Multi)│
  │  4 voices ×  │         │  4 voices ×  │
  │  4-wave morph│         │  4-wave morph│
  └──────┬───────┘         └──────┬───────┘
         └──────── Mixer ─────────┘
                    ↓
            KorgLowPassFilter
                    ↓
              AudioEngine.out
                    ↓
                MIDI out (parallel)
```

## Tech stack

- **Language:** Swift 5
- **Platform:** iOS 13+ (UIKit, Storyboard)
- **Audio:** [AudioKit](https://github.com/AudioKit/AudioKit) v5, `SoundpipeAudioKit`, `CAudioKitEX`
- **DSP primitives used:** `MorphingOscillator`, `Mixer`, `KorgLowPassFilter`, `AudioEngine`, AudioKit `MIDI`

## Build & run

1. Clone the repo.
2. Open `UOY_m1d1.xcodeproj` in Xcode (15+).
3. Add the AudioKit dependencies via Swift Package Manager:
   - `https://github.com/AudioKit/AudioKit`
   - `https://github.com/AudioKit/SoundpipeAudioKit`
   - `https://github.com/AudioKit/AudioKitEX`
4. Select an iPad simulator or a connected iPad, then ▶ Build & Run.
5. (Optional) Connect a virtual MIDI receiver (e.g. GarageBand, Logic, or a hardware synth) to hear the MIDI-out side of the engine.

## Background

This was the first hands-on audio-programming module on my MSc Audio & Music Technology at the University of York. The brief asked for a multi-oscillator polyphonic synth on iPad with a touch-driven UI, polyphony, an envelope, and a filter. The challenge was less about the DSP primitives — AudioKit gives those — and more about voice allocation, layering two oscillators cleanly, and getting the touch handling to feel responsive while keeping the audio thread well-behaved.

## Honest limitations / what I'd improve next

A few things I would change if I picked this up today:

- Voice stealing is naive (round-robin via a counter rather than oldest-note or quietest-note). On rapid playing the wrong voice can be cut.
- `Oscillators.setPlay(...)` calls `sleep(UInt32(attack))` between attack and decay ramps, which blocks the calling thread. Should be replaced with scheduled ramps or AudioKit's `AmplitudeEnvelope` driven from a tap.
- Level cycling uses float equality (`level1 == 0.4`) which is brittle — should use a discrete enum/state.
- The two oscillators share a single low-pass filter; per-oscillator filtering would be a natural next feature.
- No preset save / recall.
- No unit tests yet; the audio classes are testable with mocked oscillator inputs.

## License

MIT — see [LICENSE](LICENSE).
