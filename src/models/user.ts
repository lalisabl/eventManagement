import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';

// Define interface for User document
interface IUser extends Document {
  fullName: string;
  username: string;
  email: string;
  password: string;
  profileImage?: string;
  jobTitle?: string; // New field
  company?: string; // New field
  phoneNumber?: string; // New field
  createdAt: Date;
  updatedAt: Date;
}

// Define schema for User document
const UserSchema: Schema = new Schema(
  {
    fullName: { type: String, required: true },
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    profileImage: { type: String },
    jobTitle: { type: String },
    company: { type: String },
    phoneNumber: { type: String },
  },
  { timestamps: true }
);

// Joi validation schema for User
const userValidationSchema = Joi.object({
  fullName: Joi.string().required(),
  username: Joi.string().required(),
  email: Joi.string().email().required(),
  password: Joi.string().required(),
  profileImage: Joi.string().allow(null, ''),
  jobTitle: Joi.string().allow(null, ''),
  company: Joi.string().allow(null, ''),
  phoneNumber: Joi.string().allow(null, ''),
});

// Validate user input using Joi schema
const validateUser = (user: IUser) => {
  return userValidationSchema.validate(user);
};

// Create and export User model
const User = mongoose.model<IUser>('User', UserSchema);

export { User, validateUser };
