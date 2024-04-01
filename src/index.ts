import express from 'express';
import dotenv from 'dotenv';
// Load environment variables
dotenv.config();

// Create Express app
const app = express();

// Middleware
app.use(express.json());
// app.use(cors());
// app.use(morgan('dev'));

// Routes
app.get('/', (req, res) => {
  res.send('Hello, world!');
});

export default app;
