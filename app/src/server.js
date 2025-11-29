const app = require('./app');

const PORT = process.env.PORT || 3000;
const ENV = process.env.ENV || 'UNKNOWN';

const server = app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌍 Environment: ${ENV}`);
  console.log(`⏰ Started at: ${new Date().toISOString()}`);
});

// Manejo de cierre graceful
process.on('SIGTERM', () => {
  console.log('SIGTERM received, closing server gracefully...');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

module.exports = server;
