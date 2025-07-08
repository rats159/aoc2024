package day3

import "../common"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:text/regex"

data :: #load("data.txt", string)

main :: proc() {
	common.assert_leakless(part1)
	common.assert_leakless(part2)
}

part1 :: proc() {
	data := data
	matcher :=
		regex.create_iterator(data, `mul\((\d{1,3}),(\d{1,3})\)`) or_else panic(
			"Regex creation failed!",
		)
	defer regex.destroy_iterator(matcher)

	total := 0

	for match in regex.match_iterator(&matcher) {
		a := strconv.atoi(match.groups[1])
		b := strconv.atoi(match.groups[2])
		total += a * b
	}

	fmt.println(total)
}


part2 :: proc() {
	data := data

	// Would break for functions with the wrong arity, hopefully that's fine
	matcher :=
		regex.create_iterator(data, `(mul|do|don't)\((?:(\d{1,3}),(\d{1,3}))?\)`) or_else panic(
			"Regex creation failed!",
		)

	defer regex.destroy_iterator(matcher)

	total := 0

	cares := true

	for match in regex.match_iterator(&matcher) {
		type := match.groups[1]
		if strings.compare(type, "mul") == 0 {
			if cares {
				a := strconv.atoi(match.groups[2])
				b := strconv.atoi(match.groups[3])
				total += a * b
			}
		} else if strings.compare(type, "do") == 0 {
			cares = true
		} else if strings.compare(type, "don't") == 0 {
			cares = false
		} else do fmt.panicf("Regex matched wrong, %s", type)


	}

	fmt.println(total)
}
