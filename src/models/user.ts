import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import crypto from "crypto";
import { Strategy as GoogleStrategy, Profile } from 'passport-google-oauth20';

// Define interface for User document
interface UserDocument extends Document {
  firstName: string;
  lastName:string;
  username: string;
  email: string;
  password:string;  
  profileImage?: string;
  jobTitle?: string;
  company?: string;
  phoneNumber?: string;
  organization?: {
    name: string;
    description?: string;
  };
  createdAt: Date;
  updatedAt: Date;
  comparePassword: (password: string) => Promise<boolean>; // Ensure correct method definition
  passwordResetToken: String |undefined,
  passwordResetExpires: Date | undefined,
  createPasswordResetToken:()=>String,

}


// UserSchema
const UserSchema: Schema = new Schema(
  {
    fullName: { type: String },
    lastName: { type: String },
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
  firstName: Joi.string().required(),
  lastName: Joi.string().required(),
  username: Joi.string().required(),
  email: Joi.string().email().required(),
  googleId: Joi.string(), // Not required for Google sign-in
  password: Joi.string().when('googleId', {
    is: Joi.exist(),
    then: Joi.optional(), // Password is optional if googleId exists (Google sign-in)
    otherwise: Joi.required(), // Password is required if googleId doesn't exist (manual sign-up)
  }),
  profileImage: Joi.string().allow(null, ''),
  jobTitle: Joi.string().allow(null, ''),
  company: Joi.string().allow(null, ''),
  phoneNumber: Joi.string().allow(null, ''),
});


UserSchema.pre<UserDocument>('save', async function (next) {
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
const validateUser = (user: UserDocument) => {
  return userValidationSchema.validate(user);
};
// password reset token
UserSchema.methods.createPasswordResetToken = function () {
  const resetToken = crypto.randomBytes(32).toString("hex");
  this.passwordResetToken = crypto
    .createHash("sha256")
    .update(resetToken)
    .digest("hex");
  this.passwordResetExpires = Date.now() + 10 * 60 * 1000;
  return resetToken;
};

// Create and export User model
const User = mongoose.model<UserDocument>('User', UserSchema);

export { User, validateUser, UserDocument };
