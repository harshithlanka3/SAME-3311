const express = require('express');
const app = express();
const mongoose = require('mongoose');
const routes = require('./routes');

// Connect to MongoDB
// mongoose.connect('mongodb://...');

app.use(express.json()); // Middleware to parse JSON

// Use routes
app.use('/api', routes);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
