const mongoose = require('mongoose');

const SymptomSchema = new mongoose.Schema({
    name: String,
    diagnoses: [{type: mongoose.Schema.Types.ObjectId, ref: 'Diagnosis'}],
    chiefComplaints: [{type: mongoose.Schema.Types.ObjectId, ref: 'ChiefComplaint'}]
});

module.exports = mongoose.model('Symptom', SymptomSchema);