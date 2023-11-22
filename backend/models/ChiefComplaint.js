const mongoose = require('mongoose');

const ChiefComplaintSchema = new mongoose.Schema({
  name: String,
  symptoms: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Symptom' }]
});

module.exports = mongoose.model('ChiefComplaint', ChiefComplaintSchema);