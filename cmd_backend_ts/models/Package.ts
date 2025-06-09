import mongoose from 'mongoose';

const packageSchema = new mongoose.Schema({
    packageName: { type: String, required: true },
    packageVersion: { type: String, required: true },
    packageDescription: { type: String, required: true },
    packageDate: { type: String, required: true },
    packageCode: { type: String, required: true },
    commandType: { type: String, required: true }
}, { timestamps: true });


// ... your schema definition
const PackageDetails = mongoose.model('PackageDetails', packageSchema);
export default PackageDetails;