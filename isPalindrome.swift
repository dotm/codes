extension String {
    func isPalindrome() -> Bool {
        let string = self.lowercased()
        let reversedString = String(string.reversed())
        let isPalindrome = reversedString == string
        return isPalindrome
    }
}

"hello".isPalindrome()
"LOL".isPalindrome()
"Kasur ini rusak".isPalindrome()
