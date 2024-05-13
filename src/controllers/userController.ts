// Import necessary modules
import { Request, Response ,NextFunction} from 'express';
import passport from "passport";
import { Strategy as GoogleStrategy, Profile } from 'passport-google-oauth20';
import { User,UserDocument } from '../models/user';
import {sendEmail} from '../utils/email';
import jwt from "jsonwebtoken";
import crypto from "crypto";
import multer from 'multer';
import sharp from 'sharp';
import { date } from 'joi';
import { CustomError } from '../utils/errorHandler';

const multerStorage = multer.memoryStorage();
export const signToken = (id: string) => {
  return jwt.sign({ id }, process.env.JWT_SECRET_KEY as string, {
    expiresIn: '1h',
  });
};
// create and send token 
export const createSendToken =  (user: UserDocument, statusCode: number, res: Response) => {
  const token = signToken(user._id);
  const cookieOptions: any = {
    expires: new Date(
      Date.now() +
        parseInt(process.env.JWT_COOKIE_EXPIRES_IN as string, 10) *
          24 *
          60 *
          60 *
          1000
    ),
    httpOnly: true,
  };
  if (process.env.NODE_ENV === 'production') {
    cookieOptions.secure = true;
  }
  res.cookie('jwt', token, cookieOptions);
  res.status(statusCode).json({
    status: 'success',
    token,
    user
  });
};
// filter only images from files
const multerFilter = (req:Request, file:any, cb:any) => {
  if (file.mimetype.startsWith("image")) {
    cb(null, true);
  } else {
    cb(Error("Not an image! Please upload only images."), false);
  }
};
// phot upload controller
const upload = multer({
  storage: multerStorage,
  fileFilter: multerFilter,
});
// protect controller for authorization
export const protect = async (req: Request, res: Response, next: NextFunction) => {
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.cookies.jwt) {
    token = req.cookies.jwt;
  }

  try {
    if (!token) {
    throw new Error('You are not logged in! Please log in to get access!')
      // return new CustomError('You are not logged in! Please log in to get access!', 401);
    }
    const decoded = await new Promise((resolve, reject) => {
      jwt.verify(token, process.env.JWT_SECRET_KEY as string, (err: any, decoded: unknown) => {
        if (err) reject(err);
        else resolve(decoded);
      });
    }) as any;

    const currentUser = await User.findById(decoded.id);
    if (!currentUser) {
      throw new Error('No user belongs to this token')
     // return new CustomError('No user belongs to this token',401);
    }
    req.user = currentUser;
    next();
  } catch (error: any) {
throw new Error(error.message);
//return new CustomError( error.message,500);

  }
};

// photo upload controller
export const uploadUserPhoto = upload.single("profileImage");
// photo resizer controller
export const resizeUserPhoto = async (req:any, res:Response, next:NextFunction) => {
 if (!req.file) return next();
  req.file.filename = `user-${req.user?._id}.jpeg`;
  console.log(req.file.filename);
  await sharp(req.file.buffer)
    .resize(500, 500)
    .toFormat("jpeg")
    .jpeg({ quality: 90 })
    .toFile(`src/public/images/users/${req.file.filename}`);
  next();
};
// update user profile controller
export const updateProfile =async (req:any, res:Response) => {
  const user = await User.findById(req.user?.id);
  const { firstName,lastName,username} = req.body;
  let profileImage;
  if (req.file) user!.profileImage = req.file.filename;
  if (firstName) user!.firstName = firstName;
  if (lastName) user!.lastName = lastName;
  if (username) user!.username = username;
  const updatedUser = await user!.save();
  res.status(200).json({
    status: "success",
    data: { updatedUser },
  });
};
// User registration controller
export const registerUser = async (req: Request, res: Response,next:NextFunction) => {
  try {
    const {firstName,lastName, email, password,phoneNumber} = req.body;
    let username = email.split('@')[0];
    const user = new User({ email, username, password,firstName,lastName,phoneNumber });
            // Check if email is already taken
            // const existingUser = await User.findOne({ email:email });
            // if (existingUser) {
            //   return next(new CustomError('Email is already taken', 400));
            // }
    await user.save();
    createSendToken(user, 200, res);
  } 
  catch (error:any) {
    next(error);
  }
};
// login controller
export const loginUser = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }
    createSendToken(user, 200, res);
  } catch (error) {
    console.error('Error logging in:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
// Controller function to get all users
export const getAllUsers = async (req: Request, res: Response) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: 'Could not retrieve users' });
  }
};
// Controller function to get logged in user profile
export const getMe = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const user: UserDocument | undefined = req.user as UserDocument | undefined;
    if (!user) {
      return res.status(401).json({ error: 'User not authenticated' });
    }
    req.params.id = user.id;
    next();
  } catch (error) {
    next(error); // Pass any caught error to the error handler middleware
  }
};
// Controller function to get a user by ID
export const getUserById = async (req: Request, res: Response) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: 'Could not retrieve user' });
  }
};
// Controller function to update a user by ID
export const updateUserById = async (req: Request, res: Response) => {
  try {
    const { fullName, username, email, password, role, profileImage } =
      req.body;
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      { fullName, username, email, password, role, profileImage },
      { new: true }
    );
    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: 'Could not update user' });
  }
};
// Controller function to delete a user by ID
export const deleteUserById = async (req: Request, res: Response) => {
  try {
    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(deletedUser);
  } catch (err) {
    res.status(500).json({ error: 'Could not delete user' });
  }
};
// controller to logout after 10 second 
export const logoutUser = (req: Request, res: Response) => {
  res.cookie("jwt", "loggedout", {
    expires: new Date(Date.now() + 10 * 1000),//logged out after 10 sec
    httpOnly: true,
  });
  res.status(200).json({ status: "success" });
};
// Initialize Passport Google Strategy
export const CreateGoogleStrategy = () => {
  passport.use(
    new GoogleStrategy(
      {
        clientID: '525342472530-j5049f62qh691rg4akuv6nmll5slkt3p.apps.googleusercontent.com',
        clientSecret: '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',
        callbackURL: 'http://localhost:5000/api/auth/google/callback',
      },
      async (accessToken, refreshToken, profile: Profile, done) => {
        try {
          let user = await User.findOne({ googleId: profile.id });
          if (user) {
            return done(null, user);
          } else {
            const email = profile.emails && profile.emails[0].value;
            const username = email ? email.split('@')[0] : ''; // Extract username from email
            user = new User({
              username:username,
              email:email,
              googleId: profile.id,
            });
            await user.save();
            return done(null, user);
          }
        } 
        catch (error: any) {
          return done(error);
        }
        
      }
    )
  );
};
// googleSignInRedirect controller
export const googleSignInRedirect = (req: Request, res: Response) => {
  const user = req.user as UserDocument | undefined;
  if (user) {
    const token = signToken(user._id);
    const cookieOptions: any = {
      expires: new Date(
        Date.now() +
          parseInt(process.env.JWT_COOKIE_EXPIRES_IN as string, 10) *
            24 *
            60 *
            60 *
            1000
      ),
      httpOnly: true,
    };
    if (process.env.NODE_ENV === 'production') {
      cookieOptions.secure = true;
    }
    res.cookie('jwt', token, cookieOptions);
    res.status(200).json({
      status: 'success',
      redirectUrl: '/home',
      user
    });
    
  } else {
    res.status(401).json({ error: 'User not authenticated' });
  }

};
// controller to updatePassword
export const updatePassword = async (req: any, res: Response, next: NextFunction) => {
  try {
    const user: UserDocument = req.user as UserDocument;
    if (!(await user?.comparePassword(req.body.currentPassword))) {
      return res.status(401).json({ error: "Your current password is wrong." });
    }
    user!.password = req.body.newPassword;
    await user!.save();
    createSendToken(user, 200, res);
  } catch (error: any) {
    res.status(404).json({ status: "fail",message:error });
  }
};


// controller to resetPassword
export const forgotPassword = async (req:Request, res:Response, next:NextFunction) => {
  const user:UserDocument = await User.findOne({ email: req.body.email }) as UserDocument;
  if (!user) {
     res.status(404).json({ error: 'There is no user with email address.' });

  }
  const resetToken = user.createPasswordResetToken();
  const resetURL = `${req.protocol}://${req.get("host")}/api/resetPassword/${resetToken}`;
  const message = `we have recieved password reset request.please use the following link to reset your password \n\n ${resetURL}.\n\nIf you didn't forget your password, please ignore this email!`;
  try {
    await sendEmail({
      email: user.email,
      subject: "Your password reset token (valid for 10 min)",
      message,
    });
    res.status(200).json({
      status: "success",
      message: "Token sent to email!",
    });
    await user.save();
  } catch (err) {
    user.passwordResetToken = undefined;
    user.passwordResetExpires = undefined;
    await user.save();
    res.status(400).json({error:"There was an error sending the email. Try again later!"});
  }
};
export const resetPassword=async(req:Request,res:Response)=>{
  try{
    const token=crypto.createHash("sha256").update(req.params.token).digest("hex");
    const user=await User.findOne({passwordResetToken:token,passwordResetExpires:{$gt:Date.now()}});
    if(!user){
      res.status(404).json({status:'fail',message:'invalid token or expired!'})
    }
     user!.password=req.body.password;
     user!.passwordResetToken = undefined;
     user!.passwordResetExpires = undefined;
     await user!.save();
     createSendToken(user!, 200, res);
  }

catch(err){
console.log("Error",err)
res.status(404).json({status:'fail',message:err})
}
}