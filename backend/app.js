const express = require('express');
const mongoose = require('mongoose');

const app = express();
const uri = "mongodb+srv://harshithlanka03:o37Hzgqqo6f95nb0@cluster0.9kkf582.mongodb.net/?retryWrites=true&w=majority";

// MongoDB Cloud Connection
mongoose.connect(uri)
.then(() => console.log('Connected to MongoDB Cloud'))
.catch(err => console.error('Could not connect to MongoDB Cloud', err));

// Middleware to parse JSON
app.use(express.json());

// Import Routes
const chiefComplaintRoutes = require('./routes/chiefComplaintRoutes');
const symptomRoutes = require('./routes/symptomRoutes');
const diagnosisRoutes = require('./routes/diagnosisRoutes');

// Using Routes
app.use('/api/chiefComplaints', chiefComplaintRoutes);
app.use('/api/symptoms', symptomRoutes);
app.use('/api/diagnoses', diagnosisRoutes);

// Basic Route for Testing
app.get('/', (req, res) => {
  res.send('Hello from the backend server!');
});

// Server Listening on a Port
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
