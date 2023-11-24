const express = require('express');
const router = express.Router();
const {
  getAllSymptoms,
  addSymptom,
  updateSymptom
} = require('../controllers/symptomController');

router.get('/', getAllSymptoms);
router.post('/', addSymptom);
router.put('/:id', updateSymptom);

module.exports = router;
