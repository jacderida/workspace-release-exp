pub fn add_one(x: i32) -> i32 {
    x + 1
}

pub fn add_two(x: i32) -> i32 {
    x + 2
}

pub fn add_three(x: i32) -> i32 {
    x + 3
}

pub fn add_four(x: i32) -> i32 {
    x + 4
}

#[cfg(test)]
mod tests {
    use super::add_four;
    use super::add_one;
    use super::add_three;
    use super::add_two;

    #[test]
    fn should_add_one() {
        assert_eq!(2, add_one(1));
    }

    #[test]
    fn should_add_two() {
        assert_eq!(3, add_two(1));
    }

    #[test]
    fn should_add_three() {
        assert_eq!(4, add_three(1));
    }

    #[test]
    fn should_add_four() {
        assert_eq!(5, add_four(1));
    }
}
