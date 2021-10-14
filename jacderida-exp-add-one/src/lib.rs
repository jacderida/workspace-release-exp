pub fn add_one(x: i32) -> i32 {
    x + 1
}

pub fn add_two(x: i32) -> i32 {
    x + 2
}

#[cfg(test)]
mod tests {
    use super::add_one;
    use super::add_two;

    #[test]
    fn should_add_one() {
        assert_eq!(2, add_one(1));
    }

    #[test]
    fn should_add_two() {
        assert_eq!(3, add_two(1));
    }
}
