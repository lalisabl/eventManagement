import express from 'express';
import dotenv from 'dotenv';
import router from './routes/routes';
import bodyParser from 'body-parser'; // Import body-parser with TypeScript types
import { CreateGoogleStrategy } from './controllers/userController';
import passport from 'passport';
// import http from 'http';
dotenv.config();
// Create Express app
const app = express();

// Middleware
app.use(express.json());
app.use(bodyParser.json());
CreateGoogleStrategy();
app.use(passport.initialize());
// app.use(cors());
// app.use(morgan('dev'));

// Routes

app.use('/api',router)

// Load environment variables
dotenv.config();
require('../config/database');
// Set port
const PORT = process.env.PORT || 5000;


// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

