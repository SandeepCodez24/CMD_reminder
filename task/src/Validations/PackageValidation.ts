import Joi from 'joi';
export const CmdPackageValidation = Joi.object({
    packageName: Joi.string().required(),
    packageVersion: Joi.string().allow('', null),
    packageDescription: Joi.string().required(),
    packageDate: Joi.date().required(),
    packageCode: Joi.string().required(),
    commandType: Joi.string().valid(
        'ML Packages',
        'Python Packages',
        'Firebase Packages',
        'Windows Packages',
        'Linux Packages',
        'Mac Packages',
        'Git Packages'
    ).required(),
});

export const CmdPackageIdValidation = Joi.string()
    .regex(/^[0-9a-fA-F]{24}$/)
    .required();

export const UpdateCmdPackageValidation = Joi.object({
    packageId: Joi.string()
        .regex(/^[0-9a-fA-F]{24}$/)
        .required(),
    packageName: Joi.string().required(),
    packageVersion: Joi.string().allow('', null),
    packageDescription: Joi.string().required(),
    packageDate: Joi.date().required(),
    packageCode: Joi.string().required(),
    commandType: Joi.string().valid(
        'ML Packages',
        'Python Packages',
        'Firebase Packages',
        'Windows Packages',
        'Linux Packages',
        'Mac Packages',
        'Git Packages'
    ).required(),
});