// This middleware verifies JWT tokens for protected routes
// and optionally checks for required user roles (e.g., admin).

const jwt = require('jsonwebtoken');

// Middleware to verify that the request has a valid JWT token
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Expect "Bearer <token>"

  if (!token) {
    return res.status(401).json({ message: 'No token provided' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ message: 'Invalid or expired token' });
    }
    // Attach decoded user info to request so that handlers can use it
    req.user = user;
    next();
  });
}

// Middleware to ensure that the authenticated user has an admin role
function requireAdmin(req, res, next) {
  if (!req.user || req.user.role !== 'admin') {
    return res.status(403).json({ message: 'Admin access required' });
  }
  next();
}

module.exports = {
  authenticateToken,
  requireAdmin
};

