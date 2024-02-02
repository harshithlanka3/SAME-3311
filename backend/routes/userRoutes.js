const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Register a new user
// Route for user registration
router.post('/register', userController.register);

// Route for user login
router.post('/login', userController.login);

router.post('/uploadProfilePicture', userController.upload.single('profilePicture'), userController.uploadProfilePicture);


module.exports = router;
