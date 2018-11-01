require "./spec_helper"

describe MergeHeapQueue do
	describe "#push" do
		it "adds items to the queue" do
			heap = MergeHeapQueue(Int32).new
			heap.push(15)
			heap.next.should eq(15)
		end
		it "adds many items to the queue" do
			heap = MergeHeapQueue(Int32).new
			l = LFSR::Galois.new( LFSR::MAX_24 )
			500.times {|i| heap.push( l.next.to_i32 ) }

			heap.count.should eq(500)
		end
	end
end
