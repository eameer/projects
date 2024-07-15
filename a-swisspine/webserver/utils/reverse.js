const handleReverse = (word) => {
    return word.split("").reverse().map(x => {
        return x === x.toLowerCase() ? x.toUpperCase() : x.toLowerCase()
    }).join("")
}

module.exports = handleReverse