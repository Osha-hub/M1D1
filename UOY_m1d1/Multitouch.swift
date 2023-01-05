//
//  Multitouch.swift
//  UOY_m1d1
//
//  Created by Santiago Hoyos on 16/11/22.
//

import Foundation
import AudioKit

open class Multitouch{
    var voice1: Oscillators!
    var voice2: Oscillators!
    var voice3: Oscillators!
    var voice4: Oscillators!
    var mix: Mixer!
    init() {
        voice1 = Oscillators()
        voice2 = Oscillators()
        voice3 = Oscillators()
        voice4 = Oscillators()
        mix = Mixer(voice1.mix,voice2.mix,voice3.mix,voice4.mix)
    }
    open func setPolyWaveform(fromWavec: Int){
        voice1.setWave(fromWave: fromWavec)
        voice2.setWave(fromWave: fromWavec)
        voice3.setWave(fromWave: fromWavec)
        voice4.setWave(fromWave: fromWavec)
    }
    open func setVoices(fromNVoice: Int){
        voice1.setVoices(fromNV: fromNVoice)
        voice2.setVoices(fromNV: fromNVoice)
        voice3.setVoices(fromNV: fromNVoice)
        voice4.setVoices(fromNV: fromNVoice)
    }
    open func setOscLevel(toOscLevel: Double){
        voice1.setLevel(toLevel: toOscLevel)
        voice2.setLevel(toLevel: toOscLevel)
        voice3.setLevel(toLevel: toOscLevel)
        voice4.setLevel(toLevel: toOscLevel)
    }
    open func multiPlay(fromMultiCounter: Int, toMultiMidi: Int){
        switch fromMultiCounter{
        case 0: voice1.setPlay(toMidi: toMultiMidi)
        case 1: voice2.setPlay(toMidi: toMultiMidi)
        case 2: voice3.setPlay(toMidi: toMultiMidi)
        case 3: voice4.setPlay(toMidi: toMultiMidi)
        default: print("Voice does not exist")
        }
    }
    open func multiStop(fromMultiCounter: Int){
        switch fromMultiCounter{
        case 1: voice1.setStop()
        case 2: voice2.setStop()
        case 3: voice3.setStop()
        case 4: voice4.setStop()
        default: print("Voice does not exist")
        }
    }
    open func setMAttack(toMAttack: Float){
        voice1.setAttack(toAttack: toMAttack)
        voice2.setAttack(toAttack: toMAttack)
        voice3.setAttack(toAttack: toMAttack)
        voice4.setAttack(toAttack: toMAttack)
    }
    open func setMDecay(toMDecay: Float){
        voice1.setDecay(toDecay: toMDecay)
        voice2.setDecay(toDecay: toMDecay)
        voice3.setDecay(toDecay: toMDecay)
        voice4.setDecay(toDecay: toMDecay)
    }
    open func setMSustain(toMSustain: Float){
        voice1.setSustain(toSustain: toMSustain)
        voice2.setSustain(toSustain: toMSustain)
        voice3.setSustain(toSustain: toMSustain)
        voice4.setSustain(toSustain: toMSustain)
    }
    open func setMRelease(toMRelease: Float){
        voice1.setRelease(toRelease: toMRelease)
        voice2.setRelease(toRelease: toMRelease)
        voice3.setRelease(toRelease: toMRelease)
        voice4.setRelease(toRelease: toMRelease)
    }
}
