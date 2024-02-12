const admin = require('firebase-admin');

async function deleteUser(req, res) {
  const { email } = req.params;

  try {
    const userRecord = await admin.auth().getUserByEmail(email);

    await admin.auth().deleteUser(userRecord.uid);

    res.status(200).json({ message: 'User deleted successfully.' });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}
module.exports = { deleteUser };
