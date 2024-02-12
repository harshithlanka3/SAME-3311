const express = require('express');
const router = express.Router();
const {
  getAllChiefComplaints,
  addChiefComplaint,
  updateChiefComplaint
} = require('../controllers/chiefComplaintController');

router.get('/', getAllChiefComplaints);
router.post('/', addChiefComplaint);
router.put('/:id', updateChiefComplaint);

module.exports = router;
