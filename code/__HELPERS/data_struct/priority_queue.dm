/priority_queue
    var/list/heap = list()

/priority_queue/proc/enqueue(value, priority)
    heap += list(list(priority, value))
    bubble_up(heap.len)

/priority_queue/proc/dequeue()
    if (heap.len == 0)
        return null

    var/list/top = heap[1]
    heap[1] = heap[heap.len]
    heap.Cut(heap.len, heap.len)
    bubble_down(1)

    return top[2]

/priority_queue/proc/peek()
    if (heap.len == 0)
        return null
    return heap[1][2]

/priority_queue/proc/is_empty()
    return heap.len == 0

/priority_queue/proc/bubble_up(index)
	while(index > 1)
		var/parent = round(index / 2)

		if (heap[parent][1] < heap[index][1])
			break

		swap(index, parent)
		index = parent


/priority_queue/proc/bubble_down(index)
	while(index * 2 <= heap.len)
		var/child = index * 2

		if (child + 1 <= heap.len && heap[child + 1][1] < heap[child][1])
			child++

		if (heap[index][1] < heap[child][1])
			break

		swap(index, child)
		index = child


/priority_queue/proc/swap(a, b)
    var/list/temp = heap[a]
    heap[a] = heap[b]
    heap[b] = temp
