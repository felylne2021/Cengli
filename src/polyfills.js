import { Buffer } from 'buffer'

window.global = window.global ?? window
window.Buffer = window.Buffer ?? Buffer
window.process = window.process ?? { env: {} } // Minimal process polyfill
window.require = window.require ?? function () { }
// decode polyfill
if (typeof window.atob === 'undefined') {
  window.atob = function (str) {
    return Buffer.from(str, 'base64').toString('binary')
  }
}

export {}