import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';

// Define an interface for the package document
interface IPackage extends Document {
  vendorId: mongoose.Types.ObjectId;
  name: string;
  description: string;
  price: number;
  includedServices: mongoose.Types.ObjectId[];
  packageImage: string; // Add the packageImage field
}

// Define the schema for the package
const PackageSchema: Schema = new Schema(
  {
    vendorId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    name: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    includedServices: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
    packageImage: { type: String, required: true }, // Add the packageImage field
  },
  { timestamps: true }
);

// Define Joi schema for package validation
const packageJoiSchema = Joi.object({
  vendorId: Joi.string().required(),
  name: Joi.string().required(),
  description: Joi.string().required(),
  price: Joi.number().required(),
  includedServices: Joi.array().items(Joi.string().required()),
  packageImage: Joi.string().required(), // Add packageImage to the Joi schema
});

// Validate package data against Joi schema
function validatePackage(packageData: any) {
  return packageJoiSchema.validate(packageData, { abortEarly: false });
}

// Define and export the Package model
const Package = mongoose.model<IPackage>('Package', PackageSchema);

export default Package;
export { validatePackage };
