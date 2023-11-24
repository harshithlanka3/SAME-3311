const express = require('express');
const mongoose = require('mongoose');

const app = express();
const uri = "";

mongoose.connect(uri)
.then(() => console.log('Connected to MongoDB Cloud'))
.catch(err => console.error('Could not connect to MongoDB Cloud', err));

app.use(express.json());

const chiefComplaintRoutes = require('./routes/chiefComplaintRoutes');
const symptomRoutes = require('./routes/symptomRoutes');
const diagnosisRoutes = require('./routes/diagnosisRoutes');

app.use('/api/chiefComplaints', chiefComplaintRoutes);
app.use('/api/symptoms', symptomRoutes);
app.use('/api/diagnoses', diagnosisRoutes);

app.get('/', (req, res) => {
  res.send('Hello from the backend server!');
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
