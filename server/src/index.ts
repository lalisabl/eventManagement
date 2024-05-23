import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import router from './routes/routes';
import bodyParser from 'body-parser';
import { CreateGoogleStrategy } from './controllers/userController';
import passport from 'passport';
import session from 'express-session';
import { errorHandler } from './controllers/errorContoller';
import { User } from './models/user';

dotenv.config();

// Create Express app
const app = express();

// Middleware
app.use(cors());
app.use(passport.initialize());
app.use(express.json());
app.use(bodyParser.json());
CreateGoogleStrategy();

// Configure session middleware
const sessionOptions: CustomSessionOptions = {
  secret: process.env.SESSION_SECRET || 'your_secret_here',
};

interface CustomSessionOptions extends session.SessionOptions {
  secret: string;
}

app.use(session(sessionOptions));

// Route
app.use('/api', router);
app.use(express.static('src/public'));
// Load environment variables
dotenv.config();
require('../config/database');

// Serialize user
passport.serializeUser((user: any, done) => {
  done(null, user.id);
});

// Deserialize user
passport.deserializeUser((id, done) => {
  User.findById(id, (err: Error, user: any) => {
    done(err, user);
  });
});

// Error handling middleware
app.use(errorHandler);

// Set port
const PORT = process.env.PORT || 5000;

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
export default app;
