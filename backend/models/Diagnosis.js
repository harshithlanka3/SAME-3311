const mongoose = require('mongoose');

const DiagnosisSchema = new mongoose.Schema({
  name: String,
  symptoms: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Symptom' }]
});

module.exports = mongoose.model('Diagnosis', DiagnosisSchema);