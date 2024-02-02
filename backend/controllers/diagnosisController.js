const Diagnosis = require('../models/Diagnosis');

exports.getAllDiagnoses = async (req, res) => {
  try {
    const diagnoses = await Diagnosis.find().populate('symptoms');
    res.json(diagnoses);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

exports.addDiagnosis = async (req, res) => {
  try {
    const newDiagnosis = new Diagnosis(req.body);
    await newDiagnosis.save();
    res.status(201).json(newDiagnosis);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

exports.updateDiagnosis = async (req, res) => {
  try {
    const updatedDiagnosis = await Diagnosis.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updatedDiagnosis);
  } catch (error) {
    res.status(500).send(error.message);
  }
};
