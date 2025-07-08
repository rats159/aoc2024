package day1

import "core:mem"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "../common"
data :: #load("./data.txt", string)
 
main :: proc() {

	common.assert_leakless(part_1)
	common.assert_leakless(part_2)
}

part_1 :: proc() {
    data := data
	lines := [2][dynamic]int{}
	for line in strings.split_iterator(&data, "\n") {
		nums := strings.split(line, "   ", context.temp_allocator)
		append(&lines[0], strconv.atoi(nums[0]))
		append(&lines[1], strconv.atoi(nums[1]))
	}

	slice.sort(lines[0][:])
	slice.sort(lines[1][:])


	sum := 0

	for i in 0 ..< len(lines[0]) {
		x, y := lines[0][i], lines[1][i]
		sum += abs(x - y)
	}

	fmt.println(sum)

    delete(lines[0])
    delete(lines[1])

    free_all(context.temp_allocator)
}

part_2 :: proc() {
    data := data
    
    left, right := [dynamic]int{}, [dynamic]int{}
	for line in strings.split_iterator(&data, "\n") {
		nums := strings.split(line, "   ", context.temp_allocator)
		append(&left, strconv.atoi(nums[0]))
		append(&right, strconv.atoi(nums[1]))
	}

    free_all(context.temp_allocator)

    counts := map[int]int{}
    for item in right {
        counts[item] += 1
    }

    total := 0

    for item in left {
        total += item * counts[item]
    }

    fmt.println(total)
    delete(left)
    delete(right)
    delete(counts)

}