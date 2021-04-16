//get midi output
let midiOutput = null;
navigator.requestMIDIAccess()
.then(function(midiAccess) {
  const outputs = Array.from(midiAccess.outputs.values());
  midiOutput = outputs[0]
});

//send midi event
const C3 = 60
let pitch = C3
let velocity = 127
function validateChannelRange(channel){
    if(channel > 16 || channel < 1){
        throw Error("invalid channel number")
    }
}
function createNoteOnEvent(channel){ //channel is from 1 to 16
    validateChannelRange(channel)
    return 0x90 + (channel - 1)
}
function createNoteOffEvent(channel){ //channel is from 1 to 16
    validateChannelRange(channel)
    return 0x80 + (channel - 1)
}
function createCCEvent(channel){ //channel is from 1 to 16
    validateChannelRange(channel)
    return 0xB0 + (channel - 1)
}
let controllerNumber = 102
let controllerValue = 65 //1 and 65 for increment and decrement using relative MIDI CC
midiOutput.send([createCCEvent(1), controllerNumber, controllerValue])
midiOutput.send([createNoteOnEvent(16), pitch, velocity])
