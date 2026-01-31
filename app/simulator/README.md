# Data Simulator

This directory contains the mock data generator for testing and development.

## Purpose

Generate realistic test data for:
- Local development
- Integration testing
- Load testing
- Demo environments

## Structure

```
simulator/
├── src/
│   ├── generators/      # Data generators
│   ├── scenarios/       # Predefined test scenarios
│   └── config/          # Configuration
├── data/                # Sample/seed data
├── Dockerfile           # Container definition
├── package.json         # Dependencies
└── README.md
```

## Usage

### Generate Sample Data

```bash
# Generate mock users
npm run generate:users -- --count 100

# Generate mock transactions
npm run generate:transactions -- --count 1000

# Run full simulation
npm run simulate -- --scenario load-test
```

### Scenarios

1. **basic**: Minimal data for basic testing
2. **load-test**: Large dataset for performance testing
3. **edge-cases**: Data with edge cases and boundary conditions
4. **demo**: Curated data for demonstrations

## Configuration

Set environment variables:
- `SIMULATOR_OUTPUT`: Output location (database, file, API)
- `SIMULATOR_SEED`: Random seed for reproducibility
