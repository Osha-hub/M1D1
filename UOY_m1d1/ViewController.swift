//
//  ViewController.swift
//  UOY_m1d1
//
//  Created by Santiago Hoyos on 16/11/22.
//

import UIKit
import AudioKit
import AudioToolbox
import SoundpipeAudioKit

class ViewController: UIViewController {
    
    // Utilities
    var engine = AudioEngine()
    var multicounter: Int!
    var mix: Mixer!
    var m_oct: Int!
    var master: Float!
    var graphs: AUGraph!
    @IBOutlet weak var lbl_oct: UILabel!
    @IBOutlet weak var sld_Master: UISlider!

    
    // MIDI
    let midi = MIDI()
    @IBOutlet weak var lbl_midion: UILabel!
    @IBOutlet weak var lbl_midioff: UILabel!
    
    // OSC1
    var osc1: Multitouch!
    var wave1c = 1
    var voices1c = 1
    var level1 = 1.0
    
    // OSC2
    var osc2: Multitouch!
    var wave2c = 1
    var voices2c = 1
    var level2 = 1.0
    var osc2_oct: Int!
    
    // Filter
    //var filter: LowPassFilter!
    var filter: KorgLowPassFilter!
    @IBOutlet weak var sld_F_FREQ: UISlider!{
        didSet{sld_F_FREQ.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))}
    }
    
    // ADSR
    @IBOutlet weak var sld_ADSR_A: UISlider!{
        didSet{sld_ADSR_A.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))}
    }
    @IBOutlet weak var sld_ADSR_D: UISlider!{
        didSet{sld_ADSR_D.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))}
    }
    @IBOutlet weak var sld_ADSR_S: UISlider!{
        didSet{sld_ADSR_S.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))}
    }
    @IBOutlet weak var sld_ADSR_R: UISlider!{
        didSet{sld_ADSR_R.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        midi.openOutput()
        master = 0.7
        osc2_oct = 0
        m_oct = 0
        multicounter = 0
        osc1 = Multitouch()
        osc2 = Multitouch()
        mix = Mixer(osc1.mix, osc2.mix)
        mix.volume = master
        filter = KorgLowPassFilter(mix)
        engine.output = filter
        try! engine.start()
    }
    
    @IBAction func bW(_ sender: UIButton) {
        switch sender.tag{
        case 1: do{
            wave1c += 1
            if wave1c == 5 {wave1c = 1}
            osc1.setPolyWaveform(fromWavec: wave1c)
        }
        case 2: do{
            wave2c += 1
            if wave2c == 5 {wave2c = 1}
            osc2.setPolyWaveform(fromWavec: wave2c)
        }
        default: print("Oscillator does not exist")
        }
    }
    @IBAction func bV(_ sender: UIButton) {
        switch sender.tag{
        case 1: do{
            voices1c += 1
            if voices1c == 5 {voices1c = 1}
            osc1.setVoices(fromNVoice: voices1c)
        }
        case 2: do{
            voices2c += 1
            if voices2c == 5 {voices2c = 1}
            osc2.setVoices(fromNVoice: voices2c)
        }
        default: print("Oscillator does not exist")
        }
    }
    @IBAction func bL(_ sender: UIButton) {
        switch sender.tag{
        case 1: do{
            level1 -= 0.2
            if level1 == 0.4 {level1 = 1}
            osc1.setOscLevel(toOscLevel: level1)
        }
        case 2: do{
            level2 -= 0.2
            if level2 == 0.4 {level2 = 1}
            osc2.setOscLevel(toOscLevel: level2)
        }
        default: print("Oscillator does not exist")
        }
    }
    @IBAction func B_o2_up(_ sender: UIButton) {
        if osc2_oct < 2 {
            osc2_oct += 1
        }
    }
    @IBAction func B_o2_dn(_ sender: UIButton) {
        if osc2_oct > -2 {
            osc2_oct -= 1
        }
    }
    @IBAction func bKeyDn(_ sender: UIButton) {
        if multicounter < 5 {
            osc1.multiPlay(fromMultiCounter: multicounter, toMultiMidi: sender.tag+(12*m_oct))
            osc2.multiPlay(fromMultiCounter: multicounter, toMultiMidi: sender.tag+(12*m_oct)+(12*osc2_oct))
            multicounter += 1
        }
        else{
            multicounter -= 1
        }
        lbl_midion.text = String(sender.tag+(12*m_oct))
        midi.sendEvent(MIDIEvent(noteOn: UInt8(sender.tag+(12*m_oct)), velocity: 80, channel: 1))
    }
    @IBAction func bKeyUp(_ sender: UIButton) {
        osc1.multiStop(fromMultiCounter: multicounter)
        osc2.multiStop(fromMultiCounter: multicounter)
        multicounter -= 1
        midi.sendEvent(MIDIEvent(noteOn: UInt8(sender.tag+(12*m_oct)), velocity: 80, channel: 1))
        lbl_midioff.text = String(sender.tag+(12*m_oct))
    }
    
    // Filter
    @IBAction func sld_F_Freq(_ sender: UISlider) {
        filter.cutoffFrequency = sender.value
    }
    @IBAction func sld_F_Q(_ sender: UISlider) {
        filter.resonance = round(Float(sender.value))
    }
    
    // ADSR
    @IBAction func sld_Attack(_ sender: UISlider) {
        osc1.setMAttack(toMAttack: sender.value)
        osc2.setMAttack(toMAttack: sender.value)
    }
    @IBAction func sld_Decay(_ sender: UISlider) {
        osc1.setMDecay(toMDecay: sender.value)
        osc2.setMDecay(toMDecay: sender.value)
    }
    @IBAction func sld_Sustain(_ sender: UISlider) {
        osc1.setMSustain(toMSustain: sender.value)
        osc2.setMSustain(toMSustain: sender.value)
    }
    @IBAction func sld_Release(_ sender: UISlider) {
        osc1.setMRelease(toMRelease: sender.value)
        osc1.setMRelease(toMRelease: sender.value)
    }
    
    @IBAction func B_m_oct(_ sender: UIButton) {
        if m_oct < 2 {
            m_oct += 1
        }
        lbl_oct.text = String(m_oct)
    }
    @IBAction func B_m_oct_dn(_ sender: UIButton) {
        if m_oct > -2 {
            m_oct -= 1
        }
        lbl_oct.text = String(m_oct)
    }
    @IBAction func sld_masterval(_ sender: UISlider) {
        master = sender.value
        mix.volume = master
    }
}

