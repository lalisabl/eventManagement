  export class CustomError extends Error {
    statusCode: number;
    status: string;
    isOperational: boolean;
    kind?: string;
    code?: number;
    _message?: string;
  
    constructor(message: string, statusCode: number,) {
      super(message);
      this.statusCode = statusCode;
      this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
      this.isOperational = true;
      Object.setPrototypeOf(this, CustomError.prototype);
      Error.captureStackTrace(this, this.constructor);
    }
  }