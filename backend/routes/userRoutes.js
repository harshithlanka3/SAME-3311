const express = require('express');
const router = express.Router();
const { registerUser, uploadProfilePicture, upload } = require('../controllers/userController');

// Register a new user
router.post('/', registerUser);

router.post('/uploadProfilePicture', upload.single('profilePicture'), uploadProfilePicture);


module.exports = router;
