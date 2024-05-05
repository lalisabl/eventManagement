import { Request, Response, NextFunction } from 'express';
import { CustomError } from '../utils/errorHandler';
let message = null;
const handleJWTError = () => new CustomError('Invalid token. Please log in again!', 401);
const handleJWTExpiredError = () => new CustomError('Your token is expired, please login again!', 401);
const handleCastErrorDB = (err:any) => {
    message = `Invalid ${err.path}: ${err.value}.`;
    return new CustomError(message, 400);
  };
const handleDuplicateFieldError = (err:any) => {
    const field = Object.keys(err.keyValue)[0];
    message = `Duplicate key error. The value '${err.keyValue[field]}' for field '${field}' is already in use.`;
    return new CustomError( message,400);
  };
  const handleValidationErrorDB = (err:any) => {
    const errors = Object.values(err.errors).map((el:any) => el.message);
    message = `Invalid input data: ${errors.join(".")}`;
    return new CustomError(message,400);
  };
 const sendErrorDev = (err: CustomError, req: Request, res: Response, next: NextFunction) => {
  res.status(err.statusCode).json({
    status: err.status,
    error: err,
    message: err.message,
    stack: err.stack,
  });
  next(); 
};
 const sendErrorProd = (err: CustomError, res: Response, next: NextFunction) => {
  if (err.isOperational) {
    res.status(err.statusCode).json({
      status: err.status,
      message: err.message,
    });
  } else {
    console.error('ERROR 💥', err);
    res.status(500).json({
      status: 'error',
      message: 'Something went very wrong!',
    });
  }
  next(); 
};

export const errorHandler = (err: CustomError, req: Request, res: Response, next: NextFunction) => {
  console.log("Error",err);
  err.statusCode = err.statusCode || 500;
  err.status = err.status || 'error';

  if (process.env.NODE_ENV === 'development') {
    sendErrorDev(err, req, res, next);

  } else if (process.env.NODE_ENV === 'production') {
    let error = { ...err };
    if (error.kind === "ObjectId") error = handleCastErrorDB(error);
    if (error.code === 11000) error = handleDuplicateFieldError(error);
    if (error._message === "Product validation failed")
        error = handleValidationErrorDB(error);
    if (error.name === 'JsonWebTokenError') {
        error = handleJWTError();
      } 
    else if (err.name === 'TokenExpiredError') {
        error = handleJWTExpiredError();
    }




    // Add other error transformations as needed...

    sendErrorProd(error, res, next);
  }
};
