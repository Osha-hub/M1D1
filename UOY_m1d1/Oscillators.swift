//
//  Oscillators.swift
//  UOY_m1d1
//
//  Created by Santiago Hoyos on 16/11/22.
//

import Foundation
import AudioKit
import SoundpipeAudioKit
import CAudioKitEX

open class Oscillators {
    // VOICES
    var v1 : MorphingOscillator!
    var v2 : MorphingOscillator!
    var v3 : MorphingOscillator!
    var v4 : MorphingOscillator!
    var mixer: Mixer!
    
    // Amplitude
    var amp = 1.0
    var amp1 = 0.9
    var amp2 = 0.0
    var amp3 = 0.0
    var amp4 = 0.0
    
    // ADSR
    var attack = 0.5
    var decay = 0.5
    var sustain = 0.5
    var release = 0.5
    
    // Filter
    var mix: LowPassFilter!
    
    init() {
        v1 = MorphingOscillator(waveformArray: [Table(.sine),Table(.triangle),Table(.square),Table(.sawtooth)])
        v2 = MorphingOscillator(waveformArray: [Table(.sine),Table(.triangle),Table(.square),Table(.sawtooth)])
        v3 = MorphingOscillator(waveformArray: [Table(.sine),Table(.triangle),Table(.square),Table(.sawtooth)])
        v4 = MorphingOscillator(waveformArray: [Table(.sine),Table(.triangle),Table(.square),Table(.sawtooth)])
        
        v1.amplitude = 0.0
        v2.amplitude = 0.0
        v3.amplitude = 0.0
        v4.amplitude = 0.0
        v1.start()
        v2.start()
        v3.start()
        v4.start()
        
        mixer = Mixer(v1,v2,v3,v4)
        // Find a way to compress the signal
        mix = LowPassFilter(mixer)
    }
    open func setWave(fromWave: Int){
        switch fromWave{
        case 1: do{
            v1.index = 1
            v2.index = 1
            v3.index = 1
            v4.index = 1
        }
        case 2: do{
            v1.index = 2
            v2.index = 2
            v3.index = 2
            v4.index = 2
        }
        case 3: do{
            v1.index = 3
            v2.index = 3
            v3.index = 3
            v4.index = 3
        }
        case 4: do{
            v1.index = 4
            v2.index = 4
            v3.index = 4
            v4.index = 4
        }
        default: print("Wave does not exist")
        }
    }
    open func setVoices(fromNV: Int){
        switch fromNV{
        case 1: do{
            amp1 = 0.9
            amp2 = 0.0
            amp3 = 0.0
            amp4 = 0.0
            v1.detuningOffset = 0.0
        }
        case 2: do{
            v1.detuningOffset = -2
            v2.detuningOffset = 2
            amp1 = 0.8
            amp2 = 0.8
            
        }
        case 3: do{
            v1.detuningOffset = 0
            v2.detuningOffset = 5
            v3.detuningOffset = -5
            amp2 = 0.6
            amp3 = 0.6
        }
        case 4: do{
            v1.detuningOffset = -2
            v2.detuningOffset = 2
            v3.detuningOffset = -6
            v4.detuningOffset = 6
            amp1 = 0.7
            amp2 = 0.7
            amp3 = 0.3
            amp4 = 0.3
        }
        default: print("Invalid number of voices")
        }
    }
    open func setLevel(toLevel: Double){
        amp = toLevel
    }
    open func setPlay(toMidi: Int){
        v1.frequency = toMidi.midiNoteToFrequency()
        v2.frequency = toMidi.midiNoteToFrequency()
        v3.frequency = toMidi.midiNoteToFrequency()
        v4.frequency = toMidi.midiNoteToFrequency()
        v1.$amplitude.ramp(to:Float(amp*amp1),duration:Float(attack))
        v2.$amplitude.ramp(to:Float(amp*amp2),duration:Float(attack))
        v3.$amplitude.ramp(to:Float(amp*amp3),duration:Float(attack))
        v4.$amplitude.ramp(to:Float(amp*amp4),duration:Float(attack))
        sleep(UInt32(attack))
        v1.$amplitude.ramp(from:Float(amp*amp1),to: Float(sustain*amp1),duration:Float(decay))
        v2.$amplitude.ramp(from:Float(amp*amp2),to: Float(sustain*amp2),duration:Float(decay))
        v3.$amplitude.ramp(from:Float(amp*amp3),to: Float(sustain*amp3),duration:Float(decay))
        v4.$amplitude.ramp(from:Float(amp*amp4),to: Float(sustain*amp4),duration:Float(decay))
    }
    open func setStop(){
        v1.$amplitude.ramp(from:Float(sustain*amp1),to:0,duration:Float(release))
        v2.$amplitude.ramp(from:Float(sustain*amp2),to:0,duration:Float(release))
        v3.$amplitude.ramp(from:Float(sustain*amp3),to:0,duration:Float(release))
        v4.$amplitude.ramp(from:Float(sustain*amp4),to:0,duration:Float(release))
    }
    open func setFilterFreq(toFreq: Double){
        mix.cutoffFrequency = AUValue(toFreq)
    }
    open func setFilterQ(toQ: Float){
        mix.resonance = AUValue(toQ)
    }
    open func setAttack(toAttack: Float){
        attack = Double(toAttack)
    }
    open func setDecay(toDecay: Float){
        decay = Double(toDecay)
    }
    open func setSustain(toSustain: Float){
        sustain = Double(toSustain)
    }
    open func setRelease(toRelease: Float){
        release = Double(toRelease)
    }
}
