const http = require("http");

const server = http.createServer((req, res) => {
  const env = process.env.ENV || "UNKNOWN";
  res.end(`App running in ${env} environment`);
});

server.listen(3000, () => {
  console.log("App running on port 3000");
});
