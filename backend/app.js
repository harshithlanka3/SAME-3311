const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();


const app = express();
const uri = process.env.MONGODB_URI;

mongoose.connect(uri)
.then(() => console.log('Connected to MongoDB Cloud'))
.catch(err => console.error('Could not connect to MongoDB Cloud', err));

app.use(express.json());

const routes = require('./routes/index');

app.use('/api', routes);

app.get('/', (req, res) => {
  res.send('Hello from the backend server!');
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
