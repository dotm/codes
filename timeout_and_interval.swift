let delay = 2.0
DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
  /* statements */
}

let interval = 2.0
var timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(function_name), userInfo: nil, repeats: true)
