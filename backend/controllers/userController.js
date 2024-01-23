const User = require('../models/User');

// Register new user
const registerUser = async (req, res) => {
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

module.exports = {
  registerUser,
};
