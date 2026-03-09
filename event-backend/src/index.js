// Entry point for the Express server.
// This file wires up middleware, routes and starts the HTTP server.

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/authRoutes');
const adminRoutes = require('./routes/adminRoutes');
const userRoutes = require('./routes/userRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS so that the Flutter web frontend running on a different origin can call the APIs.
app.use(
  cors({
    origin: '*'
  })
);

// Parse JSON request bodies
app.use(express.json());

// Basic health-check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Mount feature routes under /api
app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api', userRoutes);

// Global error handler fallback
app.use((err, req, res, next) => {
  console.error('Unhandled error', err);
  res.status(500).json({ message: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

