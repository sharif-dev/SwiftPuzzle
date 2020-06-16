
class TrieNode {
    var children: [Character:TrieNode] = [:]
    var isFinal: Bool = false
    
    func add_child(_ character: Character) -> TrieNode {
        let node = TrieNode()
        children[character] = node
        return node
    }

    func getChild(_ character: Character) -> TrieNode {
        if let child = children[character] {
            return child
        } 
        else {
            return add_child(character)
        }
    }
}
class Trie {
    var root = TrieNode()
    
    func add_word(_ word: String){
        add_word(characters: Array(word))
    }

    func add_word(characters: [Character]) {
      var node = root
      for character in characters {
          node = node.getChild(character)
      }
      node.isFinal = true
    }
    
    func start_with_prefix(_ word: String) -> (Bool, Bool) {
        return start_with_prefix(characters: Array(word))
    }

    func start_with_prefix(characters: [Character]) -> (Bool, Bool) {
        var node : TrieNode? = root
        for character in characters {
          node = node?.children[character]
          if node == nil {
            return (false, false)
          }
        }
        if node!.isFinal{
            return (true, true)
        }
        else{
            return (true, false)
        }
    }
}

func find_neighbors(_ i: Int, _ j: Int, _ n: Int, _ m: Int) -> [(Int, Int)]{
    var neighbors: [(Int, Int)] = []
    if i + 1 < n {
        neighbors.append((i + 1, j))
    }
    if i + 1 < n && j + 1 < m {
        neighbors.append((i + 1, j + 1))
    }
    if i + 1 < n && j - 1 >= 0 {
        neighbors.append((i + 1, j - 1))
    }
    if i - 1 >= 0{
        neighbors.append((i - 1, j))
    }
    if i - 1 >= 0 && j + 1 < m {
        neighbors.append((i - 1, j + 1))
    }
    if i - 1 >= 0 && j - 1 >= 0 {
        neighbors.append((i - 1, j - 1))
    }
    if j - 1 >= 0 {
        neighbors.append((i, j - 1))
    }
    if j + 1 < m {
        neighbors.append((i, j + 1))
    }
    return neighbors
}
 



func contains(_ arrayToCheck:[(Int, Int)],_ goalValue:(Int,Int)) -> Bool {
  let (goalI, goalJ) = goalValue
  for (i, j) in arrayToCheck { 
      if i == goalI && j == goalJ{
           return true 
        }
    }
  return false
}

class Prefix{
    var content: String = ""
    var i : Int = 0
    var j : Int = 0
    var content_indexes : [(Int, Int)]?
    
    init(_ content: String, _ i: Int, _ j: Int, _ content_indexes: [(Int, Int)]?) {
        if content_indexes == nil{
            self.content_indexes = []
        }
        else{
            self.content_indexes = content_indexes
        }
        self.content = content
        self.i = i
        self.j = j
        self.content_indexes!.append((i, j))

    }
        

    func update(_ new_content: String, _ new_i: Int, _ new_j: Int)-> Prefix?{
        if contains(content_indexes!, (new_i, new_j)){
            return nil
        }
        let new_content = content + new_content
        let indexes: [(Int, Int)]? = content_indexes
        return Prefix(new_content, new_i, new_j, indexes)
    }

}

func is_not_equal(_ p1: Prefix, _ p2: Prefix)->Bool{
    for index in p1.content_indexes! {
        if !contains(p2.content_indexes!, index){
            return true

        }
    }
    return false
}

func main(){
    var answers : [Prefix] = []
    let trie = Trie()

    // let my_input: String = "LOL HANIF CD GO NOOB"
    // Reading Query
    let my_input: String? = readLine()
    let my_input_arr: [String] = my_input!.split(separator: " ").map({ (substring) in return String(substring)})
    for word in my_input_arr{
            trie.add_word(word)
    }
    // Reading Integers
    let n_m: [Int] = readLine()!.split(separator: " ").map { Int($0)! }
    let n: Int = n_m[0]
    let m: Int = n_m[1]
    
    var A : [[String]] = [] 
    
    for _ in 1...m{
        let new_line: String? = readLine()
        let new_line_arr: [String] = new_line!.split(separator: " ").map({ (substring) in return String(substring)})
        A.append(new_line_arr)
        
    }

    // let A = [["B", "O", "L", "O"],
    //     ["J", "K", "O", "N"],
    //     ["H", "L", "D", "C"],
    //     ["M", "F", "P", "K"]]
    
    // print(A)
        

    var q :[Prefix] = []


    for i in 0...(n-1){
        for j in 0...(m-1){
            q.append(Prefix(A[i][j], i, j, nil))
        }
    }
    
    while !q.isEmpty{

        let  current_query = q.removeLast()
        
        let current_prefix = current_query.content
        let current_i = current_query.i
        let current_j = current_query.j
        
        
        // print(current_query.content)
        
        let (prefix_exists, word_exists) = trie.start_with_prefix(current_prefix)
        
        if prefix_exists{
            // print(find_neighbors(current_i, current_j, n, m))
            for (neighbor_i, neighbor_j) in find_neighbors(current_i, current_j, n, m){
                let new_i = neighbor_i
                let new_j = neighbor_j
                // print("current query: \(current_query.content) and new: \(A[new_i][new_j])")

                let result = current_query.update(A[new_i][new_j], new_i, new_j)
                
                if result != nil{
                    // print("new added: \(result!.content)")
                    q.append(result!)
                }
            }
        }
        if word_exists{
            // print(current_prefix)
            // print(current_i)
            // print(current_j)
            var add: Bool = true
            for answer in answers{
                // print("check: current: \(current_prefix) ans: \(answer.content)")
                if !is_not_equal(current_query, answer){
                    add = false
                }
            }
            if add{
                answers.append(current_query)

            }
        }
    }
    
    for ans in answers{
        print(ans.content)
    }

}

main()


// https://www.onlinegdb.com/online_swift_compiler
