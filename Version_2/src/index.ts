import express, { Request, Response } from "express";

const app = express();

// Middleware
app.use(express.json());

// Example routes
app.get("/", (req: Request, res: Response) => {
  res.send("Welcome to the Node.js TypeScript API!");
});

// CRUD routes
// Get all items
app.get("/items", (req: Request, res: Response) => {
  res.json({ message: "Returning all items", data: [] });
});

// Get a specific item
app.get("/items/:id", (req: Request, res: Response) => {
  const { id } = req.params;
  res.json({ message: `Returning item with id ${id}`, data: { id } });
});

// Create an item
app.post("/items", (req: Request, res: Response) => {
  const { name } = req.body;
  res.status(201).json({ message: "Item created", data: { id: 1, name } });
});

// Update an item
app.put("/items/:id", (req: Request, res: Response) => {
  const { id } = req.params;
  const { name } = req.body;
  res.json({ message: `Item with id ${id} updated`, data: { id, name } });
});

// Delete an item
app.delete("/items/:id", (req: Request, res: Response) => {
  const { id } = req.params;
  res.json({ message: `Item with id ${id} deleted` });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

export default app;
