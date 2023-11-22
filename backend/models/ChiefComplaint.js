const mongoose = require('mongoose');

const ChiefComplaintSchema = new mongoose.Schema({
  name: String
});

module.exports = mongoose.model('ChiefComplaint', ChiefComplaintSchema);