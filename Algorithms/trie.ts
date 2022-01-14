const terminator = "\n"
type Char = string
type IndexSet = Set<Char>
interface Trie {
    [Key: string]: IndexSet;
}

function insertWord(trie: Trie, word: string){
    if (trie[word]) {
        trie[word].add(terminator)
    }else{
        trie[word] = new Set([terminator])
    }

    while(true){
        const lastCharacter = word[word.length-1]
        const wordMinusLastChar = word.slice(0,-1)
        word = wordMinusLastChar
        if(trie[word]){
            trie[word].add(lastCharacter)
        }else{
            trie[word] = new Set([lastCharacter])
        }

        if(word.length === 1){
            break
        }
    }
}

function constructTrie(words: string[]): Trie {
    let trie: Trie = {}
    for (let i = 0; i < words.length; i++) {
        const word = words[i];
        insertWord(trie,word)
    }
    return trie
}

function checkCompletionFor(trie: Trie, str: string): string[]{
    let words: string[] = []
    let set: Set<string> = trie[str]
    set.forEach(char => {
        if(char === terminator){
            words.push(str)
        }else{
            words = [...words, ...checkCompletionFor(trie, str + char)]
        }
    })
    return words
}

const trie1 = constructTrie(["hello", "hell", "hellish", "helium"])
console.log(trie1)
const result = checkCompletionFor(trie1, "hell")
console.log(result)