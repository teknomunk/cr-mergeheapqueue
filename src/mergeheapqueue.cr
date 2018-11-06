require "staticarrayheap"

class MergeHeapQueue(T)
	VERSION = "0.1.0"

	@input = StaticArrayHeap( T, 30 ).new()

	@output_a = StaticArrayHeap( T, 30 ).new()
	@side_a : MergeHeapQueue(T)?
	@total_size_a = 0

	@output_b = StaticArrayHeap( T, 30 ).new()
	@side_b : MergeHeapQueue(T)?
	@total_size_b = 0

	def count()
		@total_size_a + @total_size_b + @input.size + @output_a.size + @output_b.size
	end

	def push( value : T )
		@input.push(value)

		spill() if @input.full?
	end
	def next()
		next_impl {|i| nil }
	end
	def pop()
		next_impl do |i|
			case i
				when 1; @input.pop
				when 2
					@output_a.pop
					refill(pointerof(@output_a),@side_a) if @output_a.empty?
				when 3
					@output_b.pop
					refill(pointerof(@output_b),@side_b) if @output_b.empty?
			end
		end					
	end
	def empty?()
		return true
	end
	def spill()
		if (side_a=@side_a).nil?
			side_a = MergeHeapQueue(T).new
			@total_size_a += (@input.size - 15)
			side_a.do_spill(pointerof(@input))
		elsif (side_b=@side_b).nil?
			side_b = MergeHeapQueue(T).new
			@total_size_b += (@input.size - 15)
			side_b.do_spill(pointerof(@input))
		elsif @total_size_a < @total_size_b
			@total_size_a += (@input.size - 15)
			side_a.do_spill(pointerof(@input))
		else
			@total_size_b += (@input.size - 15)
			side_b.do_spill(pointerof(@input))
		end
	end
	def do_spill( src : Pointer(StaticArrayHeap(T,30)) )
		while src.value.size > 15
			v = src.value.next
			src.value.pop
			@input.push(v)

			# Handle spilling this level's input buffer
			spill() if @input.full?
		end
	end
	private def refill( heap, child )
		return if child.nil?

		for i in 0...30 do
			return if child.empty?
			heap.value.push(child.pop())
		end
	end
	private def next_impl()
		best = nil
		best_heap = 0
		if !@input.empty?
			best = @input.next
			best_heap = 1
		end
		if !@output_a.empty? && ( best.nil? || (candidate=@output_a.next) < best )
			best = candidate
			best_heap = 2
		end
		if !@output_b.empty? && ( best.nil? || (candidate=@output_b.next) < best )
			best = candidate
			best_heap = 3
		end

		yield best_heap
		return best
	end
end
