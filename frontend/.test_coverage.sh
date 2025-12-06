#!/bin/bash

# Script to run tests with coverage and generate report

echo "Running Flutter tests with coverage..."
flutter test --coverage

echo "Generating coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "Coverage report generated in coverage/html/"
echo "Open coverage/html/index.html in your browser to view the report"

