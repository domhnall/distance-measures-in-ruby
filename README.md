# Implementing distance metrics using ruby

This small repo is intended to act as a demonstration of a number
of distance metrics, relevant to the field of machine learning, as
implemented in ruby.

The distance metrics implemented are:
* `euclidean_distance`
* `manhattan_distance`
* `chebyshev_distance`
* `minkowski_distance`
* `hamming_distance`
* `cosine_similarity`
* `jaccard_similarity`

The metrics are defined as class methods on the `Metrics` class, and
each method takes two equal-length arrays.
The `minkowski_distance` takes an additional parameter for the p-value.

To run the tests:

> rspec spec/metrics_spec.rb


Please refer to the [blog
article](https://www.vector-logic.com/blog/posts/common-distance-metrics-implemented-in-ruby)
for a more detailed discussion of these metrics and their implementation.
