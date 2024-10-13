package main

import (
	"fmt"
	"math"
)

// CalculateGeometricMean calculates the geometric mean of numbers provided in the input map.
func CalculateGeometricMean(input map[string]interface{}) (GeometricMeanResponse, error) {
	// Extract numbers from input
	numbersInterface, ok := input["numbers"].([]interface{})
	if !ok {
		return GeometricMeanResponse{GeometricMean: 0}, fmt.Errorf("input does not contain a valid 'numbers' array")
	}
	// Convert interface{} to float64
	numbers := make([]float64, len(numbersInterface))
	for i, num := range numbersInterface {
		if n, ok := num.(float64); ok {
			numbers[i] = n
		} else {
			return GeometricMeanResponse{GeometricMean: 0}, fmt.Errorf("invalid number type found in array")
		}
	}
	// Calculate the product
	product := 1.0
	for _, num := range numbers {
		if num < 0 {
			return GeometricMeanResponse{GeometricMean: 0}, fmt.Errorf("negative numbers are not allowed for geometric mean calculation")
		}
		product *= num
	}
	// If there are no numbers, return 0 or handle as appropriate
	if len(numbers) == 0 {
		return GeometricMeanResponse{GeometricMean: 0}, nil
	}
	// Compute geometric mean
	geoMean := math.Pow(product, 1.0/float64(len(numbers)))
	// Check for NaN, although in Go, Pow won't return NaN for these inputs, but we'll check for safety
	if math.IsNaN(geoMean) {
		geoMean = 0
	}
	return GeometricMeanResponse{GeometricMean: float32(geoMean)}, nil
}
