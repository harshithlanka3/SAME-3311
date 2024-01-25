const User = require('../models/User');
const ProfilePicture = require('../models/ProfilePicture');
const multer = require('multer');


// Register new user
exports.registerUser = async (req, res) => {
  try {
    const { email, username, password } = req.body;

    // Validation checks
    if (!email || !username || !password) {
      return res.status(400).json({ error: 'Please fill out all fields to sign up.' });
    }

    // Additional validation checks (you may want to modify these)
    // ...

    // Create a new User instance
    const user = new User({
      email,
      username,
      password,
    });

    // Save the user to the database
    await user.save();

    res.status(201).json({ message: 'User registered successfully.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};


exports.upload = multer({
  limits: {
    fileSize: 2 * 1024 * 1024 // Limit to 2MB
  },
  fileFilter(req, file, cb) {
    if (!file.originalname.match(/\.(jpg|jpeg|png)$/)) {
      return cb(new Error('Please upload an image (jpg, jpeg, png).'));
    }
    cb(undefined, true);
  }
});

exports.uploadProfilePicture = async (req, res) => {
  try {
    const user = await User.findById(req.body.userId);
    if (!user) {
      return res.status(404).send('User not found');
    }

    // Create a new profile picture
    const newProfilePicture = new ProfilePicture({
      user: user._id,
      imageData: {
        data: req.file.buffer,
        contentType: req.file.mimetype
      }
    });
    await newProfilePicture.save();

    // If user already has a profile picture, delete it
    if (user.profilePicture) {
      await ProfilePicture.findByIdAndDelete(user.profilePicture);
    }

    // Update user with the new profile picture's ID
    user.profilePicture = newProfilePicture._id;
    await user.save();

    res.status(200).send('Profile picture updated successfully');
  } catch (error) {
    res.status(500).send(error.message);
  }
};
