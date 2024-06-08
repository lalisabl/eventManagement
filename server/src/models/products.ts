import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';

// Define an interface for the product document
interface IProduct extends Document {
  vendorId: mongoose.Types.ObjectId;
  name: string;
  description: string;
  price: number;
  productImage: string; // Updated to productImage
  packageId: mongoose.Types.ObjectId; // Add packageId
}

// Define the schema for the product
const ProductSchema: Schema = new Schema(
  {
    vendorId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    name: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    productImage: { type: String, required: true }, // Updated to productImage
    packageId: { type: Schema.Types.ObjectId, ref: 'Package' }, // Add packageId
  },
  { timestamps: true }
);

// Define Joi schema for product validation
const productJoiSchema = Joi.object({
  vendorId: Joi.string().required(),
  name: Joi.string().required(),
  description: Joi.string().required(),
  price: Joi.number().required(),
  productImage: Joi.string().required(), // Updated to productImage
  packageId: Joi.string(), // Add packageId to validation schema
});

// Validate product data against Joi schema
function validateProduct(productData: any) {
  return productJoiSchema.validate(productData, { abortEarly: false });
}

// Define and export the Product model
const Product = mongoose.model<IProduct>('Product', ProductSchema);

export default Product;
export { validateProduct };
