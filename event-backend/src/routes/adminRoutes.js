// This router exposes admin-only APIs for managing events
// and viewing registration counts per event.

const express = require('express');
const pool = require('../db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();

// GET /api/admin/events - list all events with registration counts
router.get('/events', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT e.*,
              COUNT(r.id) AS registration_count
       FROM events e
       LEFT JOIN registrations r ON e.id = r.event_id
       GROUP BY e.id
       ORDER BY e.date ASC`
    );
    res.json(rows);
  } catch (err) {
    console.error('Error fetching admin events', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// POST /api/admin/events - create a new event
router.post('/events', authenticateToken, requireAdmin, async (req, res) => {
  const { title, description, date, location } = req.body;

  if (!title || !date || !location) {
    return res
      .status(400)
      .json({ message: 'Title, date and location are required' });
  }

  try {
    const [result] = await pool.query(
      'INSERT INTO events (title, description, date, location, created_by) VALUES (?, ?, ?, ?, ?)',
      [title, description || '', date, location, req.user.id]
    );
    res.status(201).json({
      message: 'Event created successfully',
      eventId: result.insertId
    });
  } catch (err) {
    console.error('Error creating event', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// PUT /api/admin/events/:id - update an existing event
router.put('/events/:id', authenticateToken, requireAdmin, async (req, res) => {
  const { id } = req.params;
  const { title, description, date, location } = req.body;

  try {
    const [result] = await pool.query(
      'UPDATE events SET title = ?, description = ?, date = ?, location = ? WHERE id = ?',
      [title, description || '', date, location, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Event not found' });
    }

    res.json({ message: 'Event updated successfully' });
  } catch (err) {
    console.error('Error updating event', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// DELETE /api/admin/events/:id - delete an event
router.delete(
  '/events/:id',
  authenticateToken,
  requireAdmin,
  async (req, res) => {
    const { id } = req.params;

    try {
      const [result] = await pool.query('DELETE FROM events WHERE id = ?', [
        id
      ]);

      if (result.affectedRows === 0) {
        return res.status(404).json({ message: 'Event not found' });
      }

      res.json({ message: 'Event deleted successfully' });
    } catch (err) {
      console.error('Error deleting event', err);
      res.status(500).json({ message: 'Internal server error' });
    }
  }
);

module.exports = router;

