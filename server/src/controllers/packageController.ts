import { Request, Response } from 'express';
import Package, { validatePackage } from '../models/packageModel';
import { User, UserDocument } from '../models/user';

// Create a new package
export const createPackage = async (req: Request, res: Response) => {
  const { name, description, price, includedServices } = req.body;

  // Ensure user is authenticated
  if (!req.user || !(req.user as UserDocument)._id) {
    return res.status(401).json({ message: 'User not authenticated' });
  }

  const vendorId = (req.user as UserDocument)._id.toString();

  console.log('VendorId:', vendorId); // Debug log

  const { error } = validatePackage({
    vendorId,
    name,
    description,
    price,
    includedServices,
    packageImage: req.file?.path,
  });

  if (error) {
    return res
      .status(400)
      .send(error.details.map((detail) => detail.message).join(', '));
  }

  const packageData = {
    vendorId: vendorId,
    name,
    description,
    price,
    includedServices: includedServices ? includedServices.split(',') : [],
    packageImage: req.file ? req.file.path : '',
  };

  try {
    const packagep = new Package(packageData);
    const savedPackage = await packagep.save();
    res.status(201).json(savedPackage);
  } catch (err) {
    res.status(500).send((err as Error).message);
  }
};

class APIfeatures {
  query: any;
  queryString: any;
  constructor(query: any, queryString: any) {
    this.query = query;
    this.queryString = queryString;
  }
  multfilter() {
    const searchQuery = (this.queryString.q || '').toLowerCase();
    if (typeof searchQuery === 'string') {
      const regexSearch = {
        $or: [
          { name: { $regex: searchQuery, $options: 'i' } },
          { description: { $regex: searchQuery, $options: 'i' } },
          // { price: { $regex: searchQuery, $options: 'i' } },
        ],
      };
      this.query.find(regexSearch);
    }
    return this;
  }
  filter() {
    //1 build query
    const queryObj = { ...this.queryString };
    const excludedFields = ['page', 'limit', 'sort', 'fields', 'q'];
    excludedFields.forEach((el) => delete queryObj[el]);
    // advanced query
    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(
      /\b(gte|gt|lte|lt|eq)\b/g,
      (match) => `$${match}`
    );
    this.query = this.query.find(JSON.parse(queryStr));
    return this;
  }
  sort() {
    if (this.queryString.sort) {
      const sortBy = this.queryString.sort.split(',').join(' ');
      this.query = this.query.sort(sortBy);
    } else {
      this.query = this.query.sort('-createdAt');
    }
    return this;
  }
  limiting() {
    if (this.queryString.fields) {
      const selectedFields = this.queryString.fields.split(',').join(' ');
      this.query = this.query.select(selectedFields);
    } else {
      this.query = this.query.select('-__v');
    }
    return this;
  }
  paginatinating() {
    const page = this.queryString.page * 1 || 1;
    const limit = this.queryString.limit * 1 || 10;
    const skip = (page - 1) * limit;
    this.query = this.query.skip(skip).limit(limit);
    return this;
  }
}

// Get all packages
export const getAllPackages = async (req: Request, res: Response) => {
  
  try {
    const features = new APIfeatures(Package.find(), req.query)
      .multfilter()
      .filter()
      .sort()
      .limiting()
      .paginatinating();
    const packages = await features.query.select();
    res.send(packages);
  } catch (error) {
    console.error('Error fetching events:', error);
    res.status(500).send('Server error');
  }
};

export const getMyPackages = async (req: Request, res: Response) => {
  try {
    const userId = (req.user as UserDocument)._id; // Assuming user ID is available in req.user
    const packages = await Package.find({ vendorId: userId }).populate(
      'vendorId'
    ); // Assuming 'vendorId' field references the User model

    res.status(200).json({ packages });
  } catch (error) {
    console.error('Error fetching packages:', error);
    res.status(500).json({ error: 'Failed to fetch packages' });
  }
};

// Get a single package by ID
export const getPackageById = async (req: Request, res: Response) => {
  try {
    const packagep = await Package.findById(req.params.id).populate(
      'vendorId includedServices'
    );
    if (!packagep) return res.status(404).send('Package not found');
    res.json(packagep);
  } catch (err) {
    res.status(500).send((err as Error).message);
  }
};

// Update a package by ID
export const updatePackageById = async (req: Request, res: Response) => {
  const { error } = validatePackage(req.body);
  if (error)
    return res
      .status(400)
      .send(error.details.map((detail) => detail.message).join(', '));

  try {
    const updatedPackage = await Package.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    if (!updatedPackage) return res.status(404).send('Package not found');
    res.json(updatedPackage);
  } catch (err) {
    res.status(500).send((err as Error).message);
  }
};

// Delete a package by ID
export const deletePackageById = async (req: Request, res: Response) => {
  try {
    const deletedPackage = await Package.findByIdAndDelete(req.params.id);
    if (!deletedPackage) return res.status(404).send('Package not found');
    res.json(deletedPackage);
  } catch (err) {
    res.status(500).send((err as Error).message);
  }
};
