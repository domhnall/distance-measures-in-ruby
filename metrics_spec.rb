require './metrics'
require 'byebug'

RSpec.describe Metrics do
  let(:vec_a) { [0, 1, 2] }
  let(:vec_b) { [1, 2, 0] }

  describe "when dealing with vectors of unequal length" do
    let(:examples) do
      [
        [[1], [0, 0]],
        [[0, 0], [1]],
        [[0, 0, 0, 0], [1, 1, 1]],
      ]
    end
    [
      :euclidean_distance,
      :manhattan_distance,
      :chebyshev_distance,
      :hamming_distance,
      :cosine_similarity,
    ].each do |measure|
      it "should return nil when :#{measure} is called" do
        examples.each do |vectors|
          expect(Metrics.send(measure, vectors[0], vectors[1])).to be_nil
        end
      end
    end

    it "should return nil when :minkowski distance is called" do
      examples.each do |vectors|
        expect(Metrics.minkowski_distance(vectors[0], vectors[1], (rand*10).ceil)).to be_nil
      end
    end

    it "should return a value when :jaccard_similarity is called" do
      examples.each do |vectors|
        expect(Metrics.jaccard_similarity(vectors[0], vectors[1])).to be_a Numeric
      end
    end
  end

  describe "when dealing with empty vectors" do
    let(:vec_a) { [] }
    let(:vec_b) { [] }
    [
      :euclidean_distance,
      :manhattan_distance,
      :chebyshev_distance,
      :hamming_distance,
      :cosine_similarity,
    ].each do |measure|
      it "should return nil when :#{measure} is called" do
        expect(Metrics.send(measure, vec_a, vec_b)).to be_nil
      end
    end

    it "should return nil when minkowski distance is called" do
      expect(Metrics.minkowski_distance(vec_a, vec_b, (rand*10).ceil)).to be_nil
    end

    it "should return nil when jaccard_similarity is called and either vector is empty" do
      expect(Metrics.jaccard_similarity(vec_a, vec_b)).to be_nil
      expect(Metrics.jaccard_similarity([1,0], vec_b)).to be_nil
      expect(Metrics.jaccard_similarity(vec_a, [1, 0])).to be_nil
    end
  end

  describe ".euclidean_distance" do
    let(:examples) do
      {
        [[0, 1, 2], [1, 2, 0]] => Math.sqrt(6),
        [[0,0], [1,0]] => 1,
        [[-1,0], [1,0]] => Math.sqrt(4),
        [[0,0,0,0], [1,0,1,0]] => Math.sqrt(2),
      }
    end

    it "should return the euclidean distance" do
      examples.each do |vectors, expected|
        expect(Metrics.euclidean_distance(vectors[0], vectors[1])).to eq expected
      end
    end
  end

  describe ".manhattan_distance" do
    let(:examples) do
      {
        [[0, 1, 2], [1, 2, 0]] => 4,
        [[0,0], [1,0]] => 1,
        [[-1,0], [1,0]] => 2,
        [[0,0,0,0], [1,0,1,0]] => 2,
      }
    end

    it "should return the manhattan distance" do
      examples.each do |vectors, expected|
        expect(Metrics.manhattan_distance(vectors[0], vectors[1])).to eq expected
      end
    end
  end

  describe ".chebyshev_distance" do
    let(:examples) do
      {
        [[0, 1, 2], [1, 2, 0]] => 2,
        [[0,0], [1,0]] => 1,
        [[-1,0], [1,0]] => 2,
        [[0,0,0,0], [1,0,1,0]] => 1,
      }
    end

    it "should return the manhattan distance" do
      examples.each do |vectors, expected|
        expect(Metrics.chebyshev_distance(vectors[0], vectors[1])).to eq expected
      end
    end
  end

  describe ".minkowski_distance" do
    describe "when p = 1" do
      let(:p) { 1 }
      let(:examples) do
        {
          [[0, 1, 2], [1, 2, 0]] => 4,
          [[0,0], [1,0]] => 1,
          [[-1,0], [1,0]] => 2,
          [[0,0,0,0], [1,0,1,0]] => 2,
        }
      end

      it "should return the manhattan distance" do
        examples.each do |vectors, expected|
          expect(Metrics.minkowski_distance(vectors[0], vectors[1], p)).to eq expected
        end
      end
    end

    describe "when p = 2" do
      let(:p) { 2 }
      let(:examples) do
        {
          [[0, 1, 2], [1, 2, 0]] => Math.sqrt(6),
          [[0,0], [1,0]] => 1,
          [[-1,0], [1,0]] => Math.sqrt(4),
          [[0,0,0,0], [1,0,1,0]] => Math.sqrt(2),
        }
      end

      it "should return the euclidean distance" do
        examples.each do |vectors, expected|
          expect(Metrics.minkowski_distance(vectors[0], vectors[1], p)).to eq expected
        end
      end
    end

    describe "when p = 1_000" do
      let(:p) { 1_000 }
      let(:examples) do
        {
          [[0, 1, 2], [1, 2, 0]] => 2,
          [[0,0], [1,0]] => 1,
          [[-1,0], [1,0]] => 2,
          [[0,0,0,0], [1,0,1,0]] => 1,
        }
      end

      it "should approach the chebyshev distance" do
        examples.each do |vectors, expected|
          expect(Metrics.minkowski_distance(vectors[0], vectors[1], p)).to be_within(0.001).of expected
        end
      end
    end
  end

  describe ".hamming_distance" do
    let(:examples) do
      {
        [[0, 1, 2], [1, 2, 0]] => 3,
        [[0,0], [1,0]] => 1,
        [[-1,0], [1,0]] => 1,
        [[0,0,0,0], [1,0,1,0]] => 2,
      }
    end

    it "should return the hamming distance" do
      examples.each do |vectors, expected|
        expect(Metrics.hamming_distance(vectors[0], vectors[1])).to eq expected
      end
    end
  end

  describe ".cosine_similarity" do
    describe "where either vector is the zero vector" do
      let(:examples) do
        [
          [[0, 0], [1, 0]],
          [[0, 0, 0], [1, 2, 0]],
          [[-1, 0], [0, 0]],
          [[1, 2, 3, 4], [0, 0, 0, 0]],
        ]
      end

      it "should return nil if either vector is the zero vector" do
        examples.each do |vectors|
          expect(Metrics.cosine_similarity(vectors[0], vectors[1])).to be_nil
        end
      end
    end

    let(:examples) do
      {
        [[0, 1, 2], [1, 2, 0]] => 0.4,
        [[-1,0], [1,0]] => -1.0,
        [[1,0,0,0], [1,0,1,0]] => 1/Math.sqrt(2),
      }
    end

    it "should return the cosine similarity" do
      examples.each do |vectors, expected|
        expect(Metrics.cosine_similarity(vectors[0], vectors[1])).to be_within(0.01).of expected
      end
    end
  end

  describe ".jaccard_similarity" do
    let(:examples) do
      {
        [[0, 1, 2], [1, 2, 0]] => 1,
        [[0, 0], [1,0]] => 0.5,
        [[-1,0], [1,0]] => 0.333,
        [[0,0,0,0], [1,0,1,0]] => 0.5,
      }
    end

    it "should return the jaccard similarity" do
      examples.each do |vectors, expected|
        expect(Metrics.jaccard_similarity(vectors[0], vectors[1])).to be_within(0.001).of expected
      end
    end
  end
end
