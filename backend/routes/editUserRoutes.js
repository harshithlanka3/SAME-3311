const express = require('express');
const router = express.Router();
const { deleteUser, updateUserRoleAdmin, updateUserRoleUser } = require('../controllers/editUserController');

router.delete('/users/:email', deleteUser);
router.put('/users/:email/admin', updateUserRoleAdmin); 
router.put('/users/:email/user', updateUserRoleUser); 

module.exports = router;
