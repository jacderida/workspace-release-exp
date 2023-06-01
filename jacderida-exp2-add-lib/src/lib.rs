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

pub fn add_five(x: i32) -> i32 {
    x + 5
}

pub fn add_six(x: i32) -> i32 {
    x + 6
}

pub fn add_seven(x: i32) -> i32 {
    x + 7
}

pub fn add_eight(x: i32) -> i32 {
    x + 8
}

pub fn add_nine(x: i32) -> i32 {
    x + 9
}

pub fn add_ten(x: i32) -> i32 {
    x + 10
}

pub fn add_eleven(x: i32) -> i32 {
    x + 11
}

pub fn add_twelve(x: i32) -> i32 {
    x + 12
}

pub fn add_thirteen(x: i32) -> i32 {
    x + 13
}

pub fn add_fourteen(x: i32) -> i32 {
    x + 14
}

#[cfg(test)]
mod tests {
    use super::add_five;
    use super::add_four;
    use super::add_one;
    use super::add_seven;
    use super::add_six;
    use super::add_three;
    use super::add_two;
    use super::add_eight;

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

    #[test]
    fn should_add_five() {
        assert_eq!(6, add_five(1));
    }

    #[test]
    fn should_add_six() {
        assert_eq!(7, add_six(1));
    }

    #[test]
    fn should_add_seven() {
        assert_eq!(8, add_seven(1));
    }

    #[test]
    fn should_add_eight() {
        assert_eq!(9, add_eight(1));
    }

    #[test]
    fn should_add_nine() {
        assert_eq!(10, add_nine(1));
    }

    #[test]
    fn should_add_ten() {
        assert_eq!(11, add_ten(1));
    }

    #[test]
    fn should_add_eleven() {
        assert_eq!(12, add_eleven(1));
    }

    #[test]
    fn should_add_twelve() {
        assert_eq!(13, add_twelve(1));
    }

    #[test]
    fn should_add_thirteen() {
        assert_eq!(14, add_twelve(1));
    }

    #[test]
    fn should_add_fourteen() {
        assert_eq!(15, add_fourteen(1));
    }
}
