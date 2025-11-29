const express = require('express');

const app = express();

// Middleware para parsear JSON
app.use(express.json());

// Variable de entorno
const ENV = process.env.ENV || 'UNKNOWN';

// Endpoint principal - Muestra el entorno actual
app.get('/', (req, res) => {
  res.json({
    message: 'Blue-Green Deployment API',
    environment: ENV,
    status: 'running',
    timestamp: new Date().toISOString()
  });
});

// Endpoint de health check
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    environment: ENV,
    uptime: process.uptime()
  });
});

// Endpoint de información del sistema
app.get('/info', (req, res) => {
  res.json({
    environment: ENV,
    version: '1.0.31',
    nodeVersion: process.version,
    platform: process.platform,
    memory: {
      total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024) + ' MB',
      used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024) + ' MB'
    }
  });
});

// Endpoint para simular una operación (útil para testing)
app.post('/echo', (req, res) => {
  const { message } = req.body;

  if (!message) {
    return res.status(400).json({
      error: 'Message is required',
      environment: ENV
    });
  }

  res.json({
    echo: message,
    environment: ENV,
    receivedAt: new Date().toISOString()
  });
});

// Endpoint de estadísticas
app.get('/stats', (req, res) => {
  res.json({
    environment: ENV,
    stats: {
      requestsHandled: 'N/A',
      uptime: `${Math.floor(process.uptime())} seconds`,
      memoryUsage: Math.round(process.memoryUsage().heapUsed / 1024 / 1024) + ' MB'
    }
  });
});

// Manejo de rutas no encontradas
app.use((req, res) => {
  res.status(404).json({
    error: 'Route not found',
    environment: ENV,
    path: req.path
  });
});

// Exportar la app para testing
module.exports = app;
