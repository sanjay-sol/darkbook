
use dep::std;

global TREE_DEPTH: u32 = 20;


pub fn compute_merkle_root(
    leaf: Field,
    index: Field,
    path: [Field; TREE_DEPTH],
) -> Field {
    let index_bits = index.to_le_bits(TREE_DEPTH as u32);
    let mut current = leaf;

    for i in 0..TREE_DEPTH {
        let path_element = path[i];
        // If index bit is 0, leaf is on the left; otherwise on the right
        let (left, right) = if index_bits[i] == 0 {
            (current, path_element)
        } else {
            (path_element, current)
        };
        current = std::hash::pedersen_hash([left, right]);
    }

    current
}

pub fn verify_merkle_proof(
    leaf: Field,
    index: Field,
    path: [Field; TREE_DEPTH],
    root: Field,
) -> bool {
    let computed_root = compute_merkle_root(leaf, index, path);
    computed_root == root
}

pub fn hash_balance_leaf(
    address_hash: Field,
    token_id: Field,
    amount: Field,
) -> Field {
    std::hash::pedersen_hash([address_hash, token_id, amount])
}

pub fn empty_leaf() -> Field {
    std::hash::pedersen_hash([0, 0, 0])
}
