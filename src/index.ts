import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import router from './routes/routes';
import bodyParser from 'body-parser'; // Import body-parser with TypeScript types
import { CreateGoogleStrategy } from './controllers/userController';
import passport from 'passport';
import session from 'express-session';
import { SessionOptions } from 'express-session';
import { User, UserDocument } from './models/user'; // Import your User model
import {errorHandler} from "./controllers/errorContoller"
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
interface CustomSessionOptions extends SessionOptions {
  secret: string;
}
app.use(session(sessionOptions));
// Route
app.use('/api',router)
// Load environment variables
dotenv.config();
require('../config/database');

// Serialize user
passport.serializeUser((user: any, done) => {
  done(null, user.id); // Serialize user by storing the user's ID in the session
});
// Deserialize user
passport.deserializeUser((id, done) => {
  User.findById(id, (err:Error, user:any) => {
    done(err, user); // Deserialize user by finding the user in the database based on the stored ID
  });
});

// Set port
const PORT = process.env.PORT || 5000;
//global Middlewares
app.use(
  cors({
    origin: "http://localhost:5000", // Set the allowed origin
    credentials: true, // Allow cookies and authentication headers
  })
);
app.use(errorHandler);
// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
// 

