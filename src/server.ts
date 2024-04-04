import http from 'http';
import app from './index';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Set port
const PORT = process.env.PORT || 3000;

// Create HTTP server
const server = http.createServer(app);

// Start server
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

