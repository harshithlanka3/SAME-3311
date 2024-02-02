const User = require('../models/User');
const ProfilePicture = require('../models/ProfilePicture');
const multer = require('multer');
// const jwt = require('jsonwebtoken');
require('dotenv').config();
const bcrypt = require('bcrypt');




// const createToken = (userId) => {
//   return jwt.sign({ id: userId }, process.env.JWT_SECRET, { expiresIn: '1d' });
// };

// Register new user
exports.register = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    // Simple regex for basic email validation
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'Invalid email format.' });
    }

    // Password validation regex
    const passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:"<>?|[\]\\;',./`~]).{8,}$/;
    if (!passwordRegex.test(password)) {
      return res.status(400).json({
        error: 'Password must be at least 8 characters long and include at least one uppercase letter, one digit, and one special character.'
      });
    }

    // const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User({ username, email, password });
    await user.save();

    // const token = createToken(user._id);
    
    res.status(201).json({ message: 'User created successfully' });
  } catch (error) {
    if (error.code === 11000) {
      res.status(400).json({ error: 'Username or email already exists.' });
    } else {
      res.status(500).json({ error: 'Error registering new user.' });
    }
  }
};


exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(401).json({ error: 'Login failed: User not found.' });
    }

    // const isMatch = await bcrypt.compare(password, user.password);
    const isMatch = password === user.password;

    if (!isMatch) {
      return res.status(401).json({ error: 'Login failed: Incorrect password.' });
    }

    // Create a token upon successful login
    // const token = createToken(user._id);
    
    res.status(200).json({ message: 'Login successful' });
  } catch (error) {
    res.status(500).json({ error: 'Internal server error during login.' });
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
