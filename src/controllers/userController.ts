// Import necessary modules
import { Request, Response ,NextFunction} from 'express';
import { User, validateUser } from '../models/user'; // Import your User model here



export const getMe = async (req: Request, res: Response, next: NextFunction) => {
  try {
    //req.params.userId = req.user.id;
    next();
  } catch (error) {
    next(error); // Pass any caught error to the error handler middleware
  }
};

// User registration controller
export const registerUser = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    let username = email.split('@')[0];
    const user = new User({ email, username, password });
    await user.save();

    const token = user.generateAuthToken();
    res.status(201).json({ token });
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
    const token = user.generateAuthToken();
    res.json({ token });
  } catch (error) {
    console.error('Error logging in:', error);
    res.status(500).json({ message: 'Server error' });
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
    res.status(201).json(newUser);
  } catch (err) {
    res.status(500).json({ error: 'Could not create user' });
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

// exports.protect =async (req, res, next) => {
//   let token;
//   if (
//     req.headers.authorization &&
//     req.headers.authorization.startsWith("Bearer")
//   ) {
//     token = req.headers.authorization.split(" ")[1];
//   } else if (req.cookies.jwt) {
//     token = req.cookies.jwt;
//   }
//   if (!token) {
//     return next(
//       new AppError("You are not logged in! Please log in to get access.", )
//     );
//   }
//   const decoded = await promisify(jwt.verify)(token, process.env.SECRET_KEY);
//   const currentUser = await User.findById(decoded.id);
//   if (!currentUser) {
//     return next(new AppError("No user is belongs to this token", 401));
//   }
//   req.user = currentUser;
//   next();
//   if (!token) {
//     return next(
//       new AppError("You are not logged in! Please log in to get access.", 401)
//     );
//   }
// };
// exports.restrictsto = (role) => {
//   return (req, res, next) => {
//     if (!(role === req.user.role)) {
//       return next(
//         new AppError(
//           "You do not have permission to this perform this action!",
//           403
//         )
//       );
//     }
//     next();
//   };
// };