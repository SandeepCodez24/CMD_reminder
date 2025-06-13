import mongoose, { Schema, Document } from 'mongoose';

export interface ICmdPackage extends Document {
    packageName: string;
    packageVersion: string;
    packageDescription: string;
    packageDate: Date;
    packageCode: string;
    commandType: string;
}

const CmdPackageSchema: Schema = new Schema({ 
    packageName: {type: String, required: true},
    packageVersion: { type: String, required: false },
    packageDescription: {type: String, required: true},
    packageDate: {type: Date, required: true},
    packageCode: {type: String, required: true},
    commandType: {type: String, required: true,enum: [
        'ML Packages',
        'Python Packages',
        'Firebase Packages',
        'Windows Packages',
        'Linux Packages',
        'Mac Packages',
        'Git Packages',
     ],
    },
  },
  {
    timestamps: true,
  }
);

export default mongoose.model<ICmdPackage>('CmdPackageModel', CmdPackageSchema);
