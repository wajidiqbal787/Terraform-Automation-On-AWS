const http = require('http');
const port = process.env.PORT || 3000;

const requestHandler = (req, res) => {
  if (req.url === '/') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello from Terraform + Node.js app!\n');
  } else {
    res.writeHead(404);
    res.end('Not Found\n');
  }
};

const server = http.createServer(requestHandler);
server.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
