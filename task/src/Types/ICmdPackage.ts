export interface ICmdPackage {
  packageName: string;
  packageVersion?: string;
  packageDescription: string;
  packageDate: Date;
  packageCode: string;
  commandType:
    | "ML Packages"
    | "Python Packages"
    | "Firebase Packages"
    | "Windows Packages"
    | "Linux Packages"
    | "Mac Packages"
    | "Git Packages";
}