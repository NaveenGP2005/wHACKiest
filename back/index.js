const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const socketIO = require("socket.io");
const http = require("http");
const Product = require("./models/product");

const app = express();
const server = http.createServer(app);
const io = socketIO(server);

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// MongoDB connection
mongoose.connect(
  "mongodb+srv://123:123@ui.zzgso.mongodb.net/?retryWrites=true&w=majority&appName=ui",
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  }
);

const db = mongoose.connection;
db.on("error", console.error.bind(console, "Connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
});

// Product API Routes
app.post("/api/add", async (req, res) => {
  let price = parseFloat(req.body.price);
  if (isNaN(price)) {
    return res.status(400).json({ message: "Invalid price" });
  }

  const product = new Product({
    name: req.body.name,
    price: price,
    image: req.body.image,
  });

  try {
    const savedProduct = await product.save();
    res.status(200).json(savedProduct);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

app.get("/api/get", async (req, res) => {
  try {
    const products = await Product.find();
    res.status(200).json({ products });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Message Schema for MongoDB
const messageSchema = new mongoose.Schema({
  message: String,
  sentbyMe: String,
  timestamp: { type: Date, default: Date.now },
});
const Message = mongoose.model("Message", messageSchema);

// WebSocket for Chat
const connectedUsers = new Set();
io.on("connection", (socket) => {
  console.log("A user connected", socket.id);

  // Emit connection event with socket ID
  socket.broadcast.emit("user-connected", socket.id);
  connectedUsers.add(socket.id);

  // Emit connected users count
  io.emit("connected", connectedUsers.size); // Just send the size, no need for extra info

  socket.on("disconnect", () => {
    console.log("User disconnected", socket.id);
    connectedUsers.delete(socket.id);
    socket.broadcast.emit("user-disconnected", socket.id);
    io.emit("connected", connectedUsers.size); // Emit updated user count
  });

  socket.on("message", async (data) => {
    const newMessage = new Message({
      message: data.message,
      sentbyMe: data.sentbyMe,
      timestamp: new Date(),
    });

    await newMessage.save();

    socket.broadcast.emit("message-received", {
      ...data,
      timestamp: newMessage.timestamp,
    });
  });

  socket.on("get-all-messages", async () => {
    const messages = await Message.find().sort({ timestamp: 1 });
    socket.emit(
      "all-messages",
      messages.map((msg) => msg.toObject()) // Serialize MongoDB document to plain object
    );
  });
});

// Start Server
const PORT = 8080;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
