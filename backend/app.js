const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();
const serviceAccount = require('./serviceAccountKey.json');
const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://sw-aid-for-med-emergencies-default-rtdb.firebaseio.com/'
});

const app = express();
const uri = process.env.MONGODB_URI;

mongoose.connect(uri)
  .then(() => console.log('Connected to MongoDB Cloud'))
  .catch(err => console.error('Could not connect to MongoDB Cloud', err));

app.use(express.json());

/*
const routes = require('./routes/index');
app.use('/api', routes);
*/

const { deleteUser, updateUserRoleAdmin, updateUserRoleUser } = require('./controllers/editUserController');
app.delete('/users/:email', deleteUser);

app.put('/users/:email/admin', updateUserRoleAdmin);
app.put('/users/:email/user', updateUserRoleUser);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

module.exports = app;
