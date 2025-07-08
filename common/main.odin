package common

import "core:fmt"
import "core:mem"
check_leaks :: proc(alloc: ^mem.Tracking_Allocator) -> bool {
	failed: bool
	for _, val in alloc.allocation_map {
		fmt.printfln("%v: Leaked %d bytes", val.location, val.size)
		if val.size != 0 {
			failed = true
		}
	}

	return failed
}

assert_leakless :: proc(procedure: proc(), loc := #caller_location) {
	old_allocator := context.allocator

	tracker := mem.Tracking_Allocator{}
	mem.tracking_allocator_init(&tracker, context.allocator)
	context.allocator = mem.tracking_allocator(&tracker)

	procedure()
	assert(!check_leaks(&tracker), "Memory leaked!", loc)

    mem.tracking_allocator_destroy(&tracker)
	
    context.allocator = old_allocator
}