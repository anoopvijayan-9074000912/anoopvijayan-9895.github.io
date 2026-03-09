// This router exposes user-facing APIs for browsing events,
// registering for events, viewing the user's registrations,
// and submitting general enquiries.

const express = require('express');
const pool = require('../db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// GET /api/events - list all events ordered by date
router.get('/events', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM events ORDER BY date ASC'
    );
    res.json(rows);
  } catch (err) {
    console.error('Error fetching events', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/events/:id - get a single event by id
router.get('/events/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const [rows] = await pool.query('SELECT * FROM events WHERE id = ?', [
      id
    ]);

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Event not found' });
    }

    res.json(rows[0]);
  } catch (err) {
    console.error('Error fetching event', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// POST /api/events/:id/register - register the authenticated user for an event
router.post('/events/:id/register', authenticateToken, async (req, res) => {
  const { id } = req.params;
  const { name, email, phone } = req.body;

  if (!name || !email || !phone) {
    return res
      .status(400)
      .json({ message: 'Name, email and phone are required' });
  }

  try {
    // Ensure event exists
    const [events] = await pool.query('SELECT id FROM events WHERE id = ?', [
      id
    ]);
    if (events.length === 0) {
      return res.status(404).json({ message: 'Event not found' });
    }

    await pool.query(
      'INSERT INTO registrations (user_id, event_id, name, email, phone) VALUES (?, ?, ?, ?, ?)',
      [req.user.id, id, name, email, phone]
    );

    res.status(201).json({ message: 'Registered for event successfully' });
  } catch (err) {
    console.error('Error registering for event', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// GET /api/my/registrations - get registrations for the authenticated user
router.get('/my/registrations', authenticateToken, async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT r.*, e.title, e.date, e.location
       FROM registrations r
       JOIN events e ON r.event_id = e.id
       WHERE r.user_id = ?
       ORDER BY e.date ASC`,
      [req.user.id]
    );
    res.json(rows);
  } catch (err) {
    console.error('Error fetching registrations', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// POST /api/enquiries - save a general enquiry from the public form
router.post('/enquiries', async (req, res) => {
  const { name, contactNumber, email, comment } = req.body;

  if (!name || !contactNumber || !email || !comment) {
    return res
      .status(400)
      .json({ message: 'Name, contact number, email and comment are required' });
  }

  if (comment.length > 300) {
    return res
      .status(400)
      .json({ message: 'Comment must be 300 characters or less' });
  }

  try {
    await pool.query(
      'INSERT INTO enquiries (name, contact_number, email, comment) VALUES (?, ?, ?, ?)',
      [name, contactNumber, email, comment]
    );
    res.status(201).json({ message: 'Enquiry submitted successfully' });
  } catch (err) {
    console.error('Error saving enquiry', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;

