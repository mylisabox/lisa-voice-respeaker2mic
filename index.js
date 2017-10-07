const LISA = require('lisa-standalone-voice-command')
const Apa102spi = require('apa102-spi')

const INTENSITY = 10

const errorColor = [255, 0, 0]
const listenColor = [0, 255, 0]
const unknownColor = [255, 0, 255]
const idleColor = [0, 0, 0]
const LedDriver = new Apa102spi(9, 100)
let idleTimer

const setIdleMode = () => {
  setColorMode(idleColor, false)
}

const setColorMode = (color, needToRestoreIdle) => {
  LedDriver.setLedColor.apply(LedDriver, [].concat(0, INTENSITY, color))
  LedDriver.setLedColor.apply(LedDriver, [].concat(1, INTENSITY, color))
  LedDriver.setLedColor.apply(LedDriver, [].concat(2, INTENSITY, color))
  LedDriver.sendLeds()
  if (needToRestoreIdle) {
    if (idleTimer) clearTimeout(idleTimer)
    idleTimer = setTimeout(() => {
      setIdleMode()
    }, 3000)
  }
}


const lisa = new LISA({
  url: 'http://mylisabox:3000',
  speaker: null,
  language: 'fr-FR',
  gSpeech: './speech/LISA-gfile.json'
})

lisa.on('hotword', () => {
  console.log('hotword detected')
  setColorMode(listenColor, false)
})
lisa.on('error', error => {
  console.error(error)
  setColorMode(errorColor, true)
})
lisa.on('final-result', sentence => console.log(sentence + ' detected'))
lisa.on('bot-result', result => {
  console.log('bot-result', result)
  if (result.action === 'UNKNOWN') {
    setColorMode(unknownColor, true)
  }
  else {
    setIdleMode()
  }
})

//lisa.trigger(1)
function exitHandler(exit) {
  setIdleMode()
  if (exit) process.exit()
}

//do something when app is closing
process.on('exit', exitHandler.bind(this));

//catches ctrl+c event
process.on('SIGINT', exitHandler.bind(this, true));