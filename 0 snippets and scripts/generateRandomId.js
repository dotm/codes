/** Generate a random string that can be used as a unique ID. */
function generateRandomId (h = 16, s = s => Math.floor(s).toString(h)) {
    return s(Date.now() / 1000) + ' '.repeat(h).replace(/./g, () => s(Math.random() * h))
}
