import express, { Request, Response } from "express";
import "dotenv/config";
const app = express();

// Middleware
app.use(express.json());

// Docs: https://sequelize.org/docs/v6/getting-started/
import { Sequelize } from "sequelize";

const user = process.env.MYSQL_USER;
const pass = process.env.MYSQL_PASSWORD;
const host = "node-ts-api-mysql";
const port = 3306;
const dbname = process.env.MYSQL_DATABASE;

// Replace user, pass, and dbname with your actual credentials
const sequelize = new Sequelize(
  `mysql://${user}:${pass}@${host}:${port}/${dbname}`,
);

// Example routes
app.get("/", async (req: Request, res: Response) => {
  try {
    await sequelize.authenticate();

    res.send("Connection has been established successfully.");
  } catch (error) {
    res.send("Unable to connect to the database.");
  }
});

app.get("/db_variables", (req: Request, res: Response) => {
  res.send(`${user}:${pass}@${host}:${port}/${dbname}`);
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

export default app;
