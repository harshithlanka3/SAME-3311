const mongoose = require('mongoose');

const profilePictureSchema = new mongoose.Schema({
  imageData: {
    data: Buffer,
    contentType: String
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }
});

module.exports = mongoose.model('ProfilePicture', profilePictureSchema);