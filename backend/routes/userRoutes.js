const express = require('express');
const router = express.Router();
const {
    registerUser
} = require('../controllers/userController');

// Register a new user
router.post('/', registerUser);

module.exports = router;
