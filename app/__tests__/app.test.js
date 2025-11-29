const request = require('supertest');
const app = require('../src/app');

describe('Blue-Green Deployment API Tests', () => {

  // TEST 1: Endpoint principal
  describe('GET /', () => {
    test('should return environment information', async () => {
      const response = await request(app).get('/');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('message');
      expect(response.body).toHaveProperty('environment');
      expect(response.body).toHaveProperty('status', 'running');
      expect(response.body).toHaveProperty('timestamp');
    });

    test('should return valid JSON', async () => {
      const response = await request(app).get('/');

      expect(response.headers['content-type']).toMatch(/json/);
      expect(response.body.message).toBe('Blue-Green Deployment API');
    });
  });

  // TEST 2: Health check endpoint
  describe('GET /health', () => {
    test('should return healthy status', async () => {
      const response = await request(app).get('/health');

      expect(response.status).toBe(200);
      expect(response.body.status).toBe('healthy');
      expect(response.body).toHaveProperty('environment');
      expect(response.body).toHaveProperty('uptime');
      expect(typeof response.body.uptime).toBe('number');
    });
  });

  // TEST 3: Info endpoint
  describe('GET /info', () => {
    test('should return system information', async () => {
      const response = await request(app).get('/info');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('environment');
      expect(response.body).toHaveProperty('version', '1.0.0');
      expect(response.body).toHaveProperty('nodeVersion');
      expect(response.body).toHaveProperty('platform');
      expect(response.body).toHaveProperty('memory');
      expect(response.body.memory).toHaveProperty('total');
      expect(response.body.memory).toHaveProperty('used');
    });
  });

  // TEST 4: Echo endpoint (POST)
  describe('POST /echo', () => {
    test('should echo back the message', async () => {
      const testMessage = 'Hello from blue-green deployment!';

      const response = await request(app)
        .post('/echo')
        .send({ message: testMessage });

      expect(response.status).toBe(200);
      expect(response.body.echo).toBe(testMessage);
      expect(response.body).toHaveProperty('environment');
      expect(response.body).toHaveProperty('receivedAt');
    });

    test('should return 400 if message is missing', async () => {
      const response = await request(app)
        .post('/echo')
        .send({});

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error', 'Message is required');
    });
  });

  // TEST 5: Stats endpoint
  describe('GET /stats', () => {
    test('should return statistics', async () => {
      const response = await request(app).get('/stats');

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('environment');
      expect(response.body).toHaveProperty('stats');
      expect(response.body.stats).toHaveProperty('uptime');
      expect(response.body.stats).toHaveProperty('memoryUsage');
    });
  });

  // TEST 6: 404 handler
  describe('GET /nonexistent', () => {
    test('should return 404 for unknown routes', async () => {
      const response = await request(app).get('/nonexistent');

      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('error', 'Route not found');
      expect(response.body).toHaveProperty('path', '/nonexistent');
    });
  });

});
