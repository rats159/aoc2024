package main

import "../common"
import "core:fmt"
import "core:hash"
import "core:os"
import "core:strings"

data :: #load("data.txt", string)

main :: proc() {
	common.assert_leakless(part1)
	common.assert_leakless(part2)
}

part1 :: proc() {
	xmas :: proc(a, b, c, d: u8) -> int {
		if a == 'X' && b == 'M' && c == 'A' && d == 'S' do return 1
		return 0
	}

	data := data

	counts := 0

	lines := strings.split_lines(data)

	for line, y in lines {
		for _, x in line {
			has_horizontal_room := x < len(line) - 3
			has_vertical_room := y < len(lines) - 3

			if has_horizontal_room {
				counts += xmas(lines[y][x], lines[y][x + 1], lines[y][x + 2], lines[y][x + 3]) // Forward horizontal
				counts += xmas(lines[y][x + 3], lines[y][x + 2], lines[y][x + 1], lines[y][x]) // Backward horizontal
			}

			if has_vertical_room {
				counts += xmas(lines[y][x], lines[y + 1][x], lines[y + 2][x], lines[y + 3][x]) // Downwards vertical
				counts += xmas(lines[y + 3][x], lines[y + 2][x], lines[y + 1][x], lines[y][x]) // Upwards vertical
			}

			if has_vertical_room && has_horizontal_room {
                // Down forwards diagonal
				counts += xmas(
					lines[y + 0][x + 0],
					lines[y + 1][x + 1],
					lines[y + 2][x + 2],
					lines[y + 3][x + 3],
				)

                // Down backwards diagonal
				counts += xmas(
					lines[y + 3][x + 3],
					lines[y + 2][x + 2],
					lines[y + 1][x + 1],
					lines[y + 0][x + 0],
				)

                // Up forwards diagonal
				counts += xmas(
					lines[y + 3][x + 0],
					lines[y + 2][x + 1],
					lines[y + 1][x + 2],
					lines[y + 0][x + 3],
				)

                // Up backwards diagonal
				counts += xmas(
					lines[y + 0][x + 3],
					lines[y + 1][x + 2],
					lines[y + 2][x + 1],
					lines[y + 3][x + 0],
				)
			}
		}
	}

	delete(lines)

	fmt.println(counts)
}

part2 :: proc() {
	data := data

	counts := 0

	lines := strings.split_lines(data)

	for line, y in lines {
		for _, x in line {
			has_horizontal_room := x < len(line) - 2
			has_vertical_room := y < len(lines) - 2
            if !has_vertical_room || !has_horizontal_room {
                continue
            }

            if lines[y+1][x+1] == 'A' {
                mas1 := lines[y][x] == 'M' && lines[y+2][x+2] == 'S' || lines[y][x] == 'S' && lines[y+2][x+2] == 'M' 
                mas2 := lines[y+2][x] == 'M' && lines[y][x+2] == 'S' || lines[y+2][x] == 'S' && lines[y][x+2] == 'M' 

                if mas1 && mas2 do counts += 1
            }
		}
	}

	delete(lines)

	fmt.println(counts)
}
