import mongoose from "mongoose";

/**
 *
 * @param connectionString 
 */
const connectToDatabase = (connectionString: string) => {
  const connect = () => {
    mongoose
      .connect(connectionString)
      .then(() => console.log("Database connection successful..."))
      .catch((error) => {
        console.error("Unable to connect to the database: " + error.message);
        process.exit(1);
      });
    mongoose.set("strictQuery", true);
  };
  connect();

  mongoose.connection.on("disconnected", () => {
    console.log("Database disconnected");
  });

  process.on("SIGINT", async () => {
    await mongoose.connection.close();
    process.exit(0);
  });
};

export default connectToDatabase;