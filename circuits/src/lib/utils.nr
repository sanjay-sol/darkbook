pub fn assert_fits_in_64_bits(value: Field) {
    let _bits = value.to_le_bits(64);
}

pub fn assert_positive_u64(value: Field) {
    assert(value != 0, "Value must be non-zero");
    assert_fits_in_64_bits(value);
}

pub fn safe_mul(a: Field, b: Field) -> Field {
    assert_fits_in_64_bits(a);
    assert_fits_in_64_bits(b);
    let result = a * b;
    // Result must fit in 128 bits (product of two 64-bit numbers)
    let _bits = result.to_le_bits(128);
    result
}

pub fn assert_gte(a: Field, b: Field) {
    let diff = a - b;
    let _bits = diff.to_le_bits(128);
}

pub fn assert_gt(a: Field, b: Field) {
    assert(a != b, "Values must not be equal");
    assert_gte(a, b);
}

pub fn field_eq(a: Field, b: Field) -> bool {
    a == b
}
