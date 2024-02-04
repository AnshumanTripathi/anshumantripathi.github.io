---
title: "Bloom Filter"
date: 2023-05-21T14:20:27-07:00
draft: false
categories:
- concepts
- tutorials
series:
- samyak
math: True
---

<!-- TOC -->
- [What is a Bloom Filter](#what-is-a-bloom-filter)
- [How to use effectively use Bloom filters](#how-to-use-effectively-use-bloom-filters)
- [Other considerations for using a bloom filter](#other-considerations-for-using-a-bloom-filter)
- [Implementing a bloom filter](#implementing-a-bloom-filter)
- [References](#references)
<!-- TOC -->

# What is a Bloom Filter
A bloom filter is a _space efficient_ probabilistic data structure that can be used to determine the membership of an element in a given set. In other words, **a bloom filter in itself does not store the elements but only keeps a probabilistic record of the existence of an element in the set.** A bloom filter uses an array of bits to determine a value's membership, making it far more space efficient than other data structures like trees.
Space efficiency is a trade-off when using bloom filters because a bloom filter is probabilistic, i.e., a bloom filter can give some amount of false positives. In other words, a bloom filter can return true for a value that might not belong to the given set. However, a bloom filter does not have false negatives, i.e., it never returns false for a value that exists because it only allows read and writes but not deletes.
The rate of false positives can be calculated with the following formula [^1]
$$f = {(1-e^{(-nk/m)})}^k$$

where
f = the false positive rate
m = number of bits in a Bloom filter
n = number of elements to insert
k = number of hash functions

This is a significant factor in deciding whether a bloom filter should be used.

# How to use effectively use Bloom filters
The efficiency of bloom filters relies on using the right setting for bits per element ($m/n$) and the number of hash functions($k$). A higher number of bits per element, like 8-10 with 2-3 hash functions, can create a bloom filter with false-positive rates of <1% [^1].
Increasing the number of hash functions might not always result in a reduced false positive rate. Furthermore, a bloom filter with many hash functions will have a higher complexity of insertion, reducing the time complexity. On the other hand, increasing the number of bits per element means the bloom filter takes more storage space which can defeat the whole purpose of using a bloom filter. It is vital to use discretion when setting the values of m, n, and k for the bloom filter.

# Other considerations for using a bloom filter
A bloom filter does not allow deletions. Other variations of bloom filters like [Counting Bloom Filters](https://en.wikipedia.org/wiki/Counting_Bloom_filter) support deletion, but they also introduce probabilities of false negatives.

Unlike Hashmaps, once a bloom filter is created, it isn't easy to scale it. In hashmaps, the map size can be increased based on the doubling function, and the entries can be rehashed. Since the bloom filter does not store the values (or any reference to actual values), scaling up a bloom filter can mean recreating the whole filter, which would lose all the original values.

Also, Bloom filters are vulnerable when the queries are not drawn uniformly and randomly. Queries in real-life scenarios are rarely uniformly random. Instead, many queries follow the Zipfian distribution, where a small number of elements is queried many times, and a large number of elements is queried only once or twice. This pattern of queries can increase our effective false positive rate if one of our "hot" elements, i.e., the elements often queried, results in a false positive. [^1]

# Implementing a bloom filter

[Let's look at a Python-based implementation of a bloom filter.](https://github.com/AnshumanTripathi/leetcode/blob/master/python_problems/duplicate_id_checker.py) The class is initialized with the intended size, and the number of desired hashes.
```python
def __init__(self, size, hashes):
    """
    Use bloom filter for a probabilistic check for duplicates
    :param size: initial size of the bloom filter
    :param hashes: Number of hashes used in the filter
    """
    self.size = size
    self.hashes = hashes
    self.bit_array = array.array('B', [0] * math.ceil(size / 8))
    self._lock = Lock()
```
Using the size, we also initialize [an array of unsigned integers split by bytes.](https://docs.python.org/3/library/array.html) We also initialize a thread `Lock()` to make updating bloom filters thread-safe.
Now let's look at the add method.

```python
def add(self, value: any):
        """
        Record the existence of the given value in the Bloom filter.
        :param value: Value to add the record of existence for in the bloom filter.
        """
        with self._lock: #1
            for index in self._get_indices(value): #2
                self.bit_array[index // 8] |= 1 << (index % 8) #3
```
It works as follows:
1. Acquire a thread lock.
2. Fetch all the required indexes based on the hashing functions and for each index;
3. Update the bits in the integer. The `1 << (index % 8)` allows us to update a single bit for the index. (To quickly understand this operation, `x << y` would effectively return $x*2^{y}$). Using a bitwise OR allows us to update the required 1s.

Let's take a look at the `_get_indices` method.

```python
def _get_indices(self, value) -> List[int]:
        """
        Get the indices for a given value. The number of indices are equivalent to the number of hashes used in the
        bloom filter
        :param value: The value to check existence in the bloom filter.
        :return: A list of indices in the bloom filter.
        """
        indices = []
        for seed in range(self.hashes):
            value_hash = hashlib.sha256(str(value).encode() + str(seed).encode()).digest()
            indices.append(int.from_bytes(value_hash, byteorder='big') % self.size)
        return indices
```
1. Iterate over the range of the given number of hashes.
2. Here, we encode the string version of the value appended with seed, calculate the sha256 hash, and get the byte message digest.
3. Convert the byte digest to an integer and mod it with the size to get the required index to store the bloom filter.

Finally, let's look at how we lookup for membership in the Bloom filter.
```python
def __contains__(self, value: any) -> bool:
        """
        Override the contains method to check for existence of the given value in the bloom filter.
        :param value: The value to make the existence check for
        :return: True if the value exists otherwise return false
        """
        for index in self._get_indices(value):
            if not (self.bit_array[index // 8] & (1 << index % 8)):
                return False
        return True
```
1. Overriding the `__contains__` method allows us to check for membership using the `in` keyword.
2. Since this method does not update the bloom filter, we don't need thread locking.
3. Fetch all the required indices and iterate over them.
4. For each index, check if the required bit is set (`1 << index % 8`) at the required index (go to bit by floor division using `//` by 8) by using a bitwise AND `&`.
5. If the bit is not set, return False.

# References
[^1]: https://freecontent.manning.com/all-about-bloom-filters/
