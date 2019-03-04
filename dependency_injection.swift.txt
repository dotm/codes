//: Playground - noun: a place where people can play

//----------------------------
//BEFORE Dependency Injection

/*
 class DragonSummoner {
 //Dragon summoner needs to know how a dragon is initialized
 let dragon = Dragon(name: "Norbert", species: "Norwegian Ridgeback")
 
 //Dragon summoner also needs to know the method name (and parameters) to summon a dragon; in this case callDragon(to:)
 func summonDragon(to location: String){
 dragon.callDragon(to: location)
 }
 }
 
 let Charlie = DragonSummoner()
 Charlie.summonDragon(to: "Hogwarts Astronomy Tower")    //Norbert the Norwegian Ridgeback is summoned to Hogwarts Astronomy Tower.
 
 class Dragon {
 let name: String
 let species: String
 init(name:String, species:String){
 self.name = name
 self.species = species
 }
 
 func callDragon(to location: String){
 print("\(name) the \(species) is summoned to \(location).")
 }
 }
 */

//----------------------------
//AFTER Dependency Injection

/*
 class DragonSummoner {
 //Dragon summoner does NOT need to know how a dragon is initialized anymore
 //since the dragon object (the dependency) is injected into the function below
 func summon(dragon: Dragon, to location: String){
 //Dragon summoner STILL needs to know the method name (and parameters) to summon the dragon; in this case callDragon(to:)
 dragon.callDragon(to: location)
 }
 }
 
 let Charlie = DragonSummoner()
 let norbert = Dragon(name: "Norbert", species: "Norwegian Ridgeback")   //norbert is the dependency that we'll inject to the summon method
 Charlie.summon(dragon: norbert, to: "Hogwarts Astronomy Tower")         //Norbert the Norwegian Ridgeback is summoned to Hogwarts Astronomy Tower.
 
 class Dragon {
 let name: String
 let species: String
 init(name:String, species:String){
 self.name = name
 self.species = species
 }
 
 func callDragon(to location: String){
 print("\(name) the \(species) is summoned to \(location).")
 }
 }
 */

//----------------------------
//AFTER Dependency Injection AND Using Protocol


protocol Summonable {
    func summon(to location: String)
}
class Summoner {
    //Summoner doesn't need to know how a dragon is initialized
    func summon(entity: Summonable, to location: String){
        //Summoner does NOT need to know the method name (and parameters) to summon the dragon anymore
        //since summoner only need to know the summon function on the protocol Summonable
        entity.summon(to: location)
    }
}

let Charlie = Summoner()
let norbert = Dragon(name: "Norbert", species: "Norwegian Ridgeback")
Charlie.summon(entity: norbert, to: "Hogwarts Astronomy Tower")     //Norbert the Norwegian Ridgeback is summoned to Hogwarts Astronomy Tower.

//Since summoner doesn't depend anymore on Dragon class (it only depends on the Summonable protocol),
//you can use it with any class that conforms to Summonable protocol
let MbahDukun = Summoner()
let tuyul = Tuyul(versi: "KW 2")
MbahDukun.summon(entity: tuyul, to: "rumah tetangga")               //Tuyul versi KW 2 meluncur ke rumah tetangga

class Tuyul: Summonable {
    let versi: String
    init(versi: String){
        self.versi = versi
    }
    
    func panggilTuyul(ke tkp: String){
        print("Tuyul versi \(versi) meluncur ke", tkp)
    }
    //Tuyul conforms to Summonable protocol
    func summon(to location: String) {
        panggilTuyul(ke: location)
    }
}
class Dragon: Summonable {
    let name: String
    let species: String
    init(name:String, species:String){
        self.name = name
        self.species = species
    }
    
    func callDragon(to location: String){
        print("\(name) the \(species) is summoned to \(location).")
    }
    func summon(to location: String) {
        callDragon(to: location)
    }
}

//--------------------------------------------------------
//THREE types of dependency injection
//--------------------------------------------------------

//----------------------------
//Initializer Injection: dependency is injected from the init method
class SummonerNinja {
    //Dependency from initializer injection can be made immutable (using let constant)
    //which decrease the possibility of bugs happening
    let summonableEntity: Summonable
    
    //Another advantage is that we can clearly see what dependencies the SummonerNinja class have
    //just by looking at the init method's parameters
    init(summonable: Summonable) {
        summonableEntity = summonable
    }
    func kuchiyoseNoJutsu(){
        summonableEntity.summon(to: "summoner ninja location")
    }
}

let Naruto = SummonerNinja(summonable: Gamakichi())
Naruto.kuchiyoseNoJutsu()                               //Gamakichi appears at summoner ninja location

class Gamakichi: Summonable {
    func summon(to location: String) {
        print("Gamakichi appears at", location)
    }
    func reverseSummoning(){
        print("Gamakichi summon ninja to Mount Myōboku")
    }
}

//----------------------------
//Property Injection: dependency is injected by setting a property of the class
class Invoker {     //DotA
    //Dependency is mutable (can be changed)
    var activeSummoningSpell: Summonable?
    //FYI, storyboard outlets also use property injection method: @IBOutlet weak var label: UILabel!
    
    func invokeSummoningAbility(){
        activeSummoningSpell?.summon(to: "in front of Invoker")
    }
}

let invoker = Invoker()
invoker.activeSummoningSpell = Tornado()
invoker.invokeSummoningAbility()                        //Tornado appears in front of Invoker
//Let's change the dependency (see one line below)
invoker.activeSummoningSpell = Meteor()
invoker.invokeSummoningAbility()                        //Meteor falls in front of Invoker

struct Meteor: Summonable {
    func summon(to location: String) {
        print("Meteor falls",location)
    }
    var description = "Carl the invoker can pull a meteor down to earth since he's a badass"
}
struct Tornado: Summonable {
    func summon(to location: String) {
        print("Tornado appears",location)
    }
}

//----------------------------
//Method Injection: dependency is injected from the parameter of a method/function
//You've seen method injection above (when we summon a dragon and a tuyul)

let tuyulOri = Tuyul(versi: "Original")
MbahDukun.summon(entity: tuyulOri, to: "rumah tetangga")    //Here, we inject the Tuyul dependency as the entity parameter of the summon(entity:to:) method

//When you use method injection, you can't access the Summonable object (the dependency) outside of the method
//(since the parameter can only be accessed inside the method)
//which can be good if you only need the dependency inside the method only

//In contrast, the Initializer injection and the Method injection technique allow the Summonable object dependency to be used outside of the object
let gamakichi = Naruto.summonableEntity as! Gamakichi                       //we can access the dependency of Initializer injection
gamakichi.reverseSummoning()                                                //Gamakichi summon ninja to Mount Myōboku
invoker.activeSummoningSpell = Meteor()
let invokerMeteorSummonAbility = invoker.activeSummoningSpell as! Meteor    //we can access the dependency of Property injection
print(invokerMeteorSummonAbility.description)                               //Carl the invoker can pull a meteor down to earth since he's a badass

//But, you still can store the dependency from method injection to the property of the class, so you can access it outside of the method
//which is like combining Method injection technique with Property injection technique
class Dukun {
    var junjungan: Summonable?  //the property we use to store the dependency
    func summon(entity: Summonable){
        entity.summon(to: "dunia nyata")
        junjungan = entity      //storing the dependency from the parameter into a class property, so that it can be accessed outside of this function
    }
}

let dukun = Dukun()
dukun.summon(entity: NyiRoroKidul())
let junjungan = dukun.junjungan as! NyiRoroKidul    //see? we can access the dependency outsied of the Dukun.summon(entity:) method
junjungan.mintaWangsit()                            //Jangan pakai sepatu hijau di pantai selatan. Nanti kotor kena air laut dan pasir.

class NyiRoroKidul: Summonable {
    func summon(to location: String) {
        print("Nyi Roro Kidul muncul di",location)
    }
    func mintaWangsit(){
        print("Jangan pakai sepatu hijau di pantai selatan. Nanti kotor kena air laut dan pasir.")
    }
}

