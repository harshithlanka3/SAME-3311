const express = require('express');
const router = express.Router();
const { deleteUser } = require('../controllers/editUserController');

router.delete('/users/:email', deleteUser);

module.exports = router;
