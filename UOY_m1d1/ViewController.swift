//
//  ViewController.swift
//  UOY_m1d1
//
//  Created by Santiago Hoyos on 16/11/22.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    // Utilities
    var engine = AudioEngine()
    var multicounter: Int!
    var mix: Mixer!
    
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
    
    // Filter
    @IBOutlet weak var sld_F_FREQ: UISlider!{
        didSet{sld_F_FREQ.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))}
    }
    @IBOutlet weak var sld_FQ: UISlider!{
        didSet{sld_FQ.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))}
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
        multicounter = 0
        osc1 = Multitouch()
        osc2 = Multitouch()
        mix = Mixer(osc1.mix, osc2.mix)
        mix.volume = 0.25
        engine.output = mix
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
    @IBAction func bKeyDn(_ sender: UIButton) {
        if multicounter < 5 {
            osc1.multiPlay(fromMultiCounter: multicounter, toMultiMidi: sender.tag)
            osc2.multiPlay(fromMultiCounter: multicounter, toMultiMidi: sender.tag)
            multicounter += 1
        }
        else{
            multicounter -= 1
        }
    }
    @IBAction func bKeyUp(_ sender: UIButton) {
        osc1.multiStop(fromMultiCounter: multicounter)
        osc2.multiStop(fromMultiCounter: multicounter)
        multicounter -= 1
    }
    
    // Filter
    @IBAction func sld_F_Freq(_ sender: UISlider) {
        osc1.multiFilterFreq(toMFreq: Double(sender.value))
        osc2.multiFilterFreq(toMFreq: Double(sender.value))
    }
    @IBAction func sld_F_Q(_ sender: UISlider) {
        osc1.multiFilterQ(toMQ: sender.value)
        osc2.multiFilterQ(toMQ: sender.value)
    }
    
    // ADSR
    @IBAction func sld_Attack(_ sender: UISlider) {
        osc1.setMAttack(toMAttack: sender.value)
    }
    @IBAction func sld_Decay(_ sender: UISlider) {
        osc1.setMDecay(toMDecay: sender.value)
    }
    @IBAction func sld_Sustain(_ sender: UISlider) {
        osc1.setMSustain(toMSustain: sender.value)
    }
    @IBAction func sld_Release(_ sender: UISlider) {
        osc1.setMRelease(toMRelease: sender.value)
    }
}

