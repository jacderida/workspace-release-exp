pub fn add_one(x: i32) -> i32 {
    x + 1
}

#[cfg(test)]
mod tests {
    use super::add_one;

    #[test]
    fn should_add_one() {
        assert_eq!(2, add_one(1));
    }
}
