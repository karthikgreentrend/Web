#!/usr/bin/env node
// Simple mock data generator for your project

const fs = require('fs');
const path = require('path');

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randomName() {
  const names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'];
  return names[randomInt(0, names.length - 1)];
}

function randomProduct() {
  const products = ['Book', 'Laptop', 'Pen', 'Phone', 'Bag', 'Watch'];
  return products[randomInt(0, products.length - 1)];
}

function generateMockOrder(id) {
  return {
    id,
    user: randomName(),
    product: randomProduct(),
    quantity: randomInt(1, 5),
    price: randomInt(10, 500),
    date: new Date(Date.now() - randomInt(0, 1000000000)).toISOString()
  };
}

function generateOrders(count = 10) {
  return Array.from({ length: count }, (_, i) => generateMockOrder(i + 1));
}

const orders = generateOrders(20);
const outPath = path.join(__dirname, 'mock-orders.json');
fs.writeFileSync(outPath, JSON.stringify(orders, null, 2));
console.log(`Mock data written to ${outPath}`);
