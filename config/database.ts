import mongoose from "mongoose";

const dbUrl = process.env.dbUrl as string; // Assuming dbUrl is defined in environment variables

mongoose
  .connect(dbUrl)
  .then(() => {
    console.log("MongoDB connected successfully");
  })
  .catch((err) => {
    console.error("MongoDB connection error:", err);
  });

export default mongoose.connection;
