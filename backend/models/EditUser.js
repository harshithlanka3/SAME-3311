const mongoose = require('mongoose');

const editUserSchema = new mongoose.Schema({
  uid: String, 
  firstName: String,
  lastName: String,
  email: String,
  role: String
});

const User = mongoose.model('EditUser', editUserSchema);

module.exports = User;
