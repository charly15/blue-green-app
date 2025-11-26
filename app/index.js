const http = require('http');
const port = process.env.PORT || 3000;
const color = process.env.APP_COLOR || 'unknown';

const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end(`App running in ${color} environment`);
});

server.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
