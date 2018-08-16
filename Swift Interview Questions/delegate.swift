protocol ButtonProtocol {
    func clicked()
}

class Button: ButtonProtocol {
    var delegate: ButtonDelegate?
    
    init(delegate: ButtonDelegate) {
        self.delegate = delegate
    }
    
    func clicked(){
        delegate?.handleClick()
    }
}

protocol ButtonDelegate {
    func handleClick()
}

struct LoginWhenClicked: ButtonDelegate {
    func handleClick() {
        print("Logging in")
    }
}
struct LogoutWhenClicked: ButtonDelegate {
    func handleClick(){
        print("Logging out")
    }
}

let loginButton = Button(delegate: LoginWhenClicked())
loginButton.clicked()

let logoutButton = Button(delegate: LogoutWhenClicked())
logoutButton.clicked()
