import {Request,Response,NextFunction} from 'express';
import CmdPackageModel from '../Models/Packagemodel';
import { CmdPackageValidation, CmdPackageIdValidation, UpdateCmdPackageValidation } from '../Validations/PackageValidation';

/**
 * Add new CMD package
 */
export const createCmdPackage = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const cmdPackageModelValidation = await CmdPackageValidation.validateAsync(req.body);

    if (!cmdPackageModelValidation) {
      return res.status(400).json({ message: "Invalid details provided." });
    }

    const cmdPackage = new CmdPackageModel({
      packageName: cmdPackageModelValidation.packageName,
      packageVersion: cmdPackageModelValidation.packageVersion,
      packageDescription: cmdPackageModelValidation.packageDescription,
      packageDate: cmdPackageModelValidation.packageDate,
      packageCode: cmdPackageModelValidation.packageCode,
      commandType: cmdPackageModelValidation.commandType,
    });

    const savedCmdPackage = await cmdPackage.save();
    res.status(201).json(savedCmdPackage);
  } catch (error: any) {
    if (error.isJoi === true) {
      return res.status(400).json({ message: "Invalid details provided." });
    }
    next(error);
  }
};

export const getAllCmdPackages = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { commandType } = req.query;
    let filter = {};
    if (commandType) {
      filter = { commandType };
    }
    const packages = await CmdPackageModel.find(filter).select(
      "_id packageName packageVersion packageDescription packageDate packageCode commandType createdAt updatedAt"
    );
    res.status(200).json(packages);
  } catch (error) {
    next(error);
  }
};

export const getCmdPackage = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const cmdPackageIdValidation = await CmdPackageIdValidation.validateAsync(req.params.packageId);

    if (!cmdPackageIdValidation) {
      return next(res.status(400).json({ message: "Invalid package ID." }));
    } else {
      const cmdPackage = await CmdPackageModel.findById(cmdPackageIdValidation).select(
        "_id packageName packageVersion packageDescription packageDate packageCode commandType createdAt updatedAt"
      );
      if (cmdPackage) {
        res.status(200).json(cmdPackage);
      } else {
        return next(res.status(404).json({ message: "Package not found." }));
      }
    }
  } catch (error) {
    next(error);
  }
};

export const deleteCmdPackage = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const cmdPackageIdValidation = await CmdPackageIdValidation.validateAsync(req.params.packageId);

    if (!cmdPackageIdValidation) {
      return next(res.status(400).json({ message: "Invalid package ID." }));
    } else {
      const deletedPackage = await CmdPackageModel.findByIdAndDelete(cmdPackageIdValidation);
      if (deletedPackage) {
        res.status(200).json(deletedPackage);
      } else {
        return next(res.status(404).json({ message: "Package not found." }));
      }
    }
  } catch (error) {
    next(error);
  }
};

export const updateCmdPackage = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const packageId = req.params.packageId;
    const updateValidation = await UpdateCmdPackageValidation.validateAsync({
      packageId,
      ...req.body,
    });

    if (!updateValidation) {
      return next(res.status(400).json({ message: "Invalid details provided." }));
    } else {
      const updatedPackage = await CmdPackageModel.findByIdAndUpdate(
        packageId,
        {
          $set: {
            packageName: updateValidation.packageName,
            packageVersion: updateValidation.packageVersion,
            packageDescription: updateValidation.packageDescription,
            packageDate: updateValidation.packageDate,
            packageCode: updateValidation.packageCode,
            commandType: updateValidation.commandType,
          },
        },
        { new: true }
      );
      if (updatedPackage) {
        res.status(200).json(updatedPackage);
      } else {
        return next(res.status(404).json({ message: "Package not found." }));
      }
    }
  } catch (error) {
    next(error);
  }
};

