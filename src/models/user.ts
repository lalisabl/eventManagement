import mongoose, { Schema, Document } from 'mongoose';

// Define interface for User document
interface IUser extends Document {
  fullName: string;
  username: string;
  email: string;
  password: string;
  role: string;
  profileImage: string;
  createdAt: Date;
  updatedAt: Date;
}

// Define schema for User document
const UserSchema: Schema = new Schema({
  fullName: { type: String, required: true },
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, required: true },
  profileImage: { type: String, required: false }, // Assuming profile image is optional
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

// Create and export User model
const User = mongoose.model<IUser>('User', UserSchema);

export default User;
