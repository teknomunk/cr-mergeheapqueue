require "./spec_helper"

describe MergeHeapQueue do
	describe "#push" do
		it "adds items to the queue" do
			heap = MergeHeapQueue(Int32).new
			heap.push(15)
			heap.next.should eq(15)
		end
	end
end
