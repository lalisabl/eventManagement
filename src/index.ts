import express from "express";
import dotenv from "dotenv";
// import http from 'http';
dotenv.config();
const bodyParser = require("body-parser");

// Create Express app
const app = express();

// Middleware
app.use(express.json());
app.use(express.json());
app.use(bodyParser.json());

// app.use(cors());
// app.use(morgan('dev'));

// Routes
app.get("/", (req, res) => {
  res.send("Hello, world!");
});

// Load environment variables
dotenv.config();
require("../config/database");
// Set port
const PORT = process.env.PORT || 5000;

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
