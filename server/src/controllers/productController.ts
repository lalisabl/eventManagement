import { Request, Response } from 'express';
const mongoose = require('mongoose');
import Product, { validateProduct } from '../models/products';
//import Product, { validateProduct, IProduct } from '../models/products'; // Import IProduct from the model file
import { IProduct } from '../models/products';
import Package from '../models/packageModel';
import { User, UserDocument } from '../models/user';
interface UpdateFields {
  name?: string;
  description?: string;
  price?: number;
  productImage?: string;
}
// Controller functions for Product CRUD operations

// Create a new product
export const createProduct = async (req: Request, res: Response) => {
  const { name, description, price, packageId } = req.body;

  if (!req.user || !(req.user as UserDocument)._id) {
    return res.status(401).json({ message: 'User not authenticated' });
  }

  const vendorId = (req.user as UserDocument)._id.toString();

  if (!packageId) {
    return res.status(400).json({ message: 'Package ID is required' });
  }

  const { error } = validateProduct({
    vendorId,
    name,
    description,
    price,
    productImage: req.file?.path,
    packageId, // Validate packageId
  });

  if (error) {
    return res
      .status(400)
      .send(error.details.map((detail) => detail.message).join(', '));
  }

  const productData = {
    vendorId: vendorId,
    name,
    description,
    price,
    productImage: req.file ? req.file.path : '',
    packageId, // Set packageId
  };

  try {
    const product = new Product(productData);
    const savedProduct = await product.save();

    // Update the package's includedServices field
    await Package.findByIdAndUpdate(packageId, {
      $push: { includedServices: savedProduct._id },
    });

    res.status(201).json({
      status: 'success',
      product: savedProduct,
      message: 'Product created successfully',
    });
  } catch (err) {
    res.status(500).send('Unable to create a product');
  }
};

export const getMyProducts = async (req: Request, res: Response) => {
  try {
    const userId = (req.user as UserDocument)._id; // Assuming user ID is available in req.user
    const products = await Product.find({ vendorId: userId }).populate([
      {
        path: 'vendorId',
        select: 'username email', // Fields to select for vendorId
      },
    ]);

    res.status(200).json({ products });
  } catch (error) {
    console.error('Error fetching packages:', error);
    res.status(500).json({ error: 'Failed to fetch packages' });
  }
};

export const getMyProductById = async (req: Request, res: Response) => {
  try {
    const productId = req.params.id;
    const userId = (req.user as UserDocument)._id;

    //  console.log(`Received request for packageId: ${packageId}`);

    const product = await Product.findOne({
      _id: productId,
      vendorId: userId,
    }).populate([
      {
        path: 'vendorId',
        select: 'username email',
      },
    ]);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // console.log(`Found package: ${packagep}`);

    res.status(200).json({ product });
  } catch (error) {
    console.error('Error fetching package:', error);
    res.status(500).json({ error: 'Failed to fetch package' });
  }
};

// Get all products
export const getAllProducts = async (req: Request, res: Response) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    res.status(500).send(err);
  }
};

// Get a product by ID
export const getProductById = async (req: Request, res: Response) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).send('Product not found');
    res.json(product);
  } catch (err) {
    res.status(500).send(err);
  }
};

// Update a product by ID
export const updateProductById = async (req: Request, res: Response) => {
  try {
    const productId = req.params.id.trim();
    const { name, description, price, productImage } = req.body;

    if (!productId || productId === ':id') {
      return res.status(400).json({ message: 'Invalid product ID' });
    }

    const updateFields = { name, description, price, productImage };
    if (req.file) {
      updateFields.productImage = req.file.path;
    }

    const updatedProduct = await Product.findByIdAndUpdate(
      productId,
      { $set: updateFields },
      { new: true }
    );

    if (!updatedProduct) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.status(200).json(updatedProduct);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
};
// Delete a product by ID
export const deleteProductById = async (req: Request, res: Response) => {
  try {
    const deletedProduct = await Product.findByIdAndDelete(req.params.id);
    if (!deletedProduct) return res.status(404).send('Product not found');
    res.json(deletedProduct);
  } catch (err) {
    res.status(500).send(err);
  }
};
