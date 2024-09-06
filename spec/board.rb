require "./lib/board"

describe Board do

    describe "#is_even?" do

        let(:mother_class){described_class.new}
        let(:even_sum){[0,2]}
        let(:uneven_sum){[1,6]}

        it 'returns true for an even sum of indexes' do
            solution=mother_class.is_even?(even_sum[0],even_sum[1])
            expect(solution).to eq(true)
        end

        it 'returns false for a uneven sum of indexes' do
            solution=mother_class.is_even?(uneven_sum[0],uneven_sum[1])
            expect(solution).to eq(false)
        end
    end

    describe "#color_piece" do
        let(:mother_class){described_class.new}
        let(:even_sum){[0,2]}
        let(:uneven_sum){[1,6]}

        before do
            allow(mother_class).to receive(:first_color).and_return(:light_white)
            allow(mother_class).to receive(:second_color).and_return(:green)
        end

        it "returns light-white for an even sum" do
            solution=mother_class.color_piece(even_sum[0],even_sum[1])
            expect(solution).to eq(:light_white)
        end

        it "returns green for an uneven sum" do
            solution=mother_class.color_piece(uneven_sum[0],uneven_sum[1])
            expect(solution).to eq(:green)
        end
    end

    describe "#is_legal?" do
        let(:mother_class){described_class.new}
        context "the legal limit is within the 0-7 bounds for indexes" do

            let(:in_bounds){[0,1]}
            let(:out_of_bounds){[0,8]}

            it 'returns true for indexes within bounds' do
                solution=mother_class.is_legal?(in_bounds[0],in_bounds[1])
                expect(solution).to eq(true)
            end


            it 'returns false for indexes out of bounds' do
                solution=mother_class.is_legal?(out_of_bounds[0],out_of_bounds[1])
                expect(solution).to eq(false)
            end
        end

        context "an argument error is issued for non integer indexes" do
            
            let(:error){['j',6]}

            it 'outputs an error' do
                solution=mother_class.is_legal?(error[0],error[1])
                expect(solution).to eq(ArgumentError)
            end
        end
    end
end