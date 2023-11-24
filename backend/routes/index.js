const express = require('express');
const chiefComplaintRoutes = require('./chiefComplaintRoutes');
const symptomRoutes = require('./symptomRoutes');
const diagnosisRoutes = require('./diagnosisRoutes');

const router = express.Router();

router.use('/chiefComplaints', chiefComplaintRoutes);
router.use('/symptoms', symptomRoutes);
router.use('/diagnoses', diagnosisRoutes);

module.exports = router;
