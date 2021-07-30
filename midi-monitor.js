// Printing all messages to console
let midiInput = null;
navigator.requestMIDIAccess().then(midiAccess => {
  const inputs = Array.from(midiAccess.inputs.values());
  midiInput = inputs[0]
});

midiInput.onmidimessage = (msg) => { console.log(msg); }