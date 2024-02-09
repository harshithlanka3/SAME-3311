const express = require('express');
const router = express.Router();
const {
  getAllDiagnoses,
  addDiagnosis,
  updateDiagnosis
} = require('../controllers/diagnosisController');

router.get('/', getAllDiagnoses);
router.post('/', addDiagnosis);
router.put('/:id', updateDiagnosis);

module.exports = router;
