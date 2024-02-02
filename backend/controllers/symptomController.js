const Symptom = require('../models/Symptom');

exports.getAllSymptoms = async (req, res) => {
  try {
    const symptoms = await Symptom.find().populate('diagnoses chiefComplaints');
    res.json(symptoms);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

exports.addSymptom = async (req, res) => {
  try {
    const newSymptom = new Symptom(req.body);
    await newSymptom.save();
    res.status(201).json(newSymptom);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

exports.updateSymptom = async (req, res) => {
  try {
    const updatedSymptom = await Symptom.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updatedSymptom);
  } catch (error) {
    res.status(500).send(error.message);
  }
};
