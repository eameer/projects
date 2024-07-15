const express = require('express');
const handleReverse = require('./utils/reverse')
const handleHealth = require('./utils/health')
const app = express();
const port = 4004;

app.get('/api/health', (req, res) => {
    res.send(handleHealth());
});

app.get('/api/mirror', (req, res) => {
    const response = handleReverse(req.query.word)
    res.send({
        transformed: response
    });
});

let server = app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});

