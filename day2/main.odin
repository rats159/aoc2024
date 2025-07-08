package day2

import "../common"
import "core:fmt"
import "core:strconv"
import "core:strings"

data :: #load("./data.txt", string)

main :: proc() {
	common.assert_leakless(part1)
	common.assert_leakless(part2)
}

atoi_basic :: #force_inline proc(c: u8) -> int {
	return int(c - '0')
}

part1 :: proc() {
    is_safe :: proc(line: string) -> bool {
	line := line

	up: Maybe(bool)
	last: Maybe(int)

	for char in strings.split_iterator(&line, " ") {
		digit := strconv.atoi(char)
		defer last = digit
		if last == nil do continue

		if up == nil {
			up = last.? < digit ? true : false
		} else if last.? < digit != up.? {
			return false
		}
		if last.? == digit {
			return false
		}
		if abs(last.? - digit) > 3 {
			return false
		}
	}
	return true
}
	data := data
	sum := 0
	for line in strings.split_lines_iterator(&data) {
		sum += is_safe(line) ? 1 : 0
	}
	fmt.println(sum)
}

part2 :: proc() {
    is_safe :: proc(line: string, ignore: int) -> bool {
	line := line

	up: Maybe(bool)
	last: Maybe(int)
    index := 0
	for char in strings.split_iterator(&line, " ") {
        defer index += 1
        if index == ignore do continue

		digit := strconv.atoi(char)
		defer last = digit
		if last == nil do continue

		if up == nil {
			up = last.? < digit ? true : false
		} else if last.? < digit != up.? {
			return false
		}
		if last.? == digit {
			return false
		}
		if abs(last.? - digit) > 3 {
			return false
		}
	}
	return true
}
	data := data
	sum := 0
	for line in strings.split_lines_iterator(&data) {
		if is_safe(line,-1) {
            sum += 1
        } else {
            num_reports := strings.count(line, " ") + 1
            for i in 0..<num_reports {
                if is_safe(line, i) {
                    sum += 1
                    break
                }
            }
        }
	}
	fmt.println(sum)
}
