const ChiefComplaint = require('../models/ChiefComplaint');

exports.getAllChiefComplaints = async (req, res) => {
  try {
    const complaints = await ChiefComplaint.find().populate('symptoms');
    res.json(complaints);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

exports.addChiefComplaint = async (req, res) => {
  try {
    const newComplaint = new ChiefComplaint(req.body);
    await newComplaint.save();
    res.status(201).json(newComplaint);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

exports.updateChiefComplaint = async (req, res) => {
  try {
    const updatedComplaint = await ChiefComplaint.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updatedComplaint);
  } catch (error) {
    res.status(500).send(error.message);
  }
};