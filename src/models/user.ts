import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

// Define interface for User document
interface IUser extends Document {
  fullName: string;
  username: string;
  email: string;
  password: string;
  profileImage?: string;
  jobTitle?: string;
  company?: string;
  phoneNumber?: string;
  organization?: {
    name: string;
    description?: string;
  };
  address?: {
    street: string;
    city: string;
    state: string;
    country: string;
    postalCode: string;
  };
  createdAt: Date;
  updatedAt: Date;
  comparePassword: (password: string) => Promise<boolean>; // Ensure correct method definition
}

// Define schema for User document
const UserSchema: Schema = new Schema(
  {
    fullName: { type: String },
    username: { type: String, unique: true },
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

UserSchema.pre<IUser>('save', async function (next) {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(this.password, salt);
    this.password = hashedPassword;
    next();
  } catch (error: any) {
    next(error);
  }
});

// Compare passwords
UserSchema.methods.comparePassword = async function (password: string) {
  return await bcrypt.compare(password, this.password);
};
// Validate user input using Joi schema
const validateUser = (user: IUser) => {
  return userValidationSchema.validate(user);
};

// Create and export User model
const User = mongoose.model<IUser>('User', UserSchema);

export { User, validateUser };
