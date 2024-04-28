// Import necessary modules
import { Request, Response ,NextFunction} from 'express';
import passport from "passport";
import { Strategy as GoogleStrategy, Profile } from 'passport-google-oauth20';
import { User,UserDocument, validateUser } from '../models/user';
import jwt from "jsonwebtoken";

export const signToken = (id: string) => {
  return jwt.sign({ id }, process.env.JWT_SECRET_KEY as string, {
    expiresIn: '1h',
  });
};

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

// User registration controller
export const registerUser = async (req: Request, res: Response) => {
  try {
    const { email, password,firstName,lastName ,phoneNumber} = req.body;
    let username = email.split('@')[0];
    const user = new User({ email, username, password,firstName,lastName,phoneNumber });
    await user.save();
    createSendToken(user, 200, res);
  } catch (error: any) {
    if (error.code === 11000) {
      return res
        .status(400)
        .json({ message: 'this email is already taken, try login' });
    } else {
      console.error('Error creating user:', error);
      return res.status(500).json({ message: 'Server error' });
    }
  }
};

// Controller function to create a new user
export const createUser = async (req: Request, res: Response) => {
  try {
    const { fullName, username, email, password, role, profileImage } =
      req.body;
    const newUser = new User({
      fullName,
      username,
      email,
      password,
      role,
      profileImage,
    });
    await newUser.save();
    createSendToken(newUser, 201, res);
  } catch (err) {
    res.status(500).json({ error: 'Could not create user' });
  }
};

// login
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
    createSendToken(user, 201, res);
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
      throw new Error('You are not logged in! Please log in to get access.');
    }
    const decoded = await new Promise((resolve, reject) => {
      jwt.verify(token, process.env.JWT_SECRET_KEY as string, (err: any, decoded: unknown) => {
        if (err) reject(err);
        else resolve(decoded);
      });
    }) as any;

    const currentUser = await User.findById(decoded.id);
    if (!currentUser) {
      throw new Error('No user belongs to this token');
    }

    req.user = currentUser;
    next();
  } catch (error: any) {
    return res.status(401).json({ error: error.message });
  }
};

// Controller function to get a user by ID
export const getUserById = async (req: Request, res: Response) => {
  try {
    console.log(req.params.id)
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
           // await user.save();
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
    createSendToken(user, 200, res);
  } else {
    // Handle the case where user is undefined
    res.status(401).json({ error: 'User not authenticated' });
  }

};

// controller to resetPassword
export const resetPassword = async (req: Request, res: Response, next: NextFunction) => {
  // Implement your reset password logic here
};

// controller to updatePassword
// export const updatePassword = async (req: Request, res: Response, next: NextFunction) => {
//   try {
//     const user = await User.findById(req.user.id).select("+password");
//     if (!(await user.validatePassword(req.body.currentPassword, user.password))) {
//       return res.status(401).json({ error: "Your current password is wrong." });
//     }
//     user.password = req.body.newPassword;
//     await user.save();
//     createSendToken(user, 200, res);
//   } catch (error: any) {
//     next(error);
//   }
// };