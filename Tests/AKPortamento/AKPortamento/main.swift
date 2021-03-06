//
//  main.swift
//  AudioKit
//
//  Created by Nick Arner and Aurelius Prochazka on 12/22/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

import Foundation

let testDuration: Float = 10.0

class Instrument : AKInstrument {

    override init() {
        super.init()

        let frequencyShifter = AKLowFrequencyOscillator()
        frequencyShifter.waveformType = AKLowFrequencyOscillator.waveformTypeForBipolarSquare()
        frequencyShifter.amplitude = 100.ak;
        frequencyShifter.frequency = 0.25.ak
        connect(frequencyShifter)

        let portamento = AKPortamento(input: frequencyShifter)
        connect(portamento)

        let sine = AKOscillator()
        sine.frequency  = portamento.plus(880.ak)
        connect(sine)

        enableParameterLog(
            "Frequency = ",
            parameter: sine.frequency,
            timeInterval:0.1
        )

        connect(AKAudioOutput(audioSource:sine))
    }
}



let instrument = Instrument()
AKOrchestra.addInstrument(instrument)

AKOrchestra.testForDuration(testDuration)

instrument.play()

let manager = AKManager.sharedManager()
while(manager.isRunning) {} //do nothing
println("Test complete!")
