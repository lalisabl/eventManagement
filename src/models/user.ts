import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';

// Define interface for User document
interface IUser extends Document {
  fullName: string;
  username: string;
  email: string;
  password: string;
  role: string;
  profileImage?: string;
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
  profileImage: { type: String }, // Profile image is now optional
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

// Joi validation schema for User
const userValidationSchema = Joi.object({
  fullName: Joi.string().required(),
  username: Joi.string().required(),
  email: Joi.string().email().required(),
  password: Joi.string().required(),
  role: Joi.string().required(),
  profileImage: Joi.string().allow(null, ''), // Allow null or empty string for optional field
});

// Validate user input using Joi schema
const validateUser = (user: IUser) => {
  return userValidationSchema.validate(user);
};

// Create and export User model
const User = mongoose.model<IUser>('User', UserSchema);

export { User, validateUser };
