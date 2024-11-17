import SwiftUI

struct ContentView: View {
    let grid = [
        ["AC", "⌦", "%", "/"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        [".", "0", "", "="]
    ]
    
    let operators = ["/", "+", "X", "%"]
    
    @State var visibleWorkings = ""
    @State var visibleResults = ""
    @State var showAlert = false
    
    var body: some View {
        VStack {
            // Displaying the workings (input)
            HStack {
                Spacer()
                Text(visibleWorkings)
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.system(size: 30, weight: .light))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Displaying the result
            HStack {
                Spacer()
                Text(visibleResults)
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.system(size: 50, weight: .bold))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // The calculator grid with buttons
            ForEach(grid, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { cell in
                        Button(action: { buttonPressed(cell: cell) }, label: {
                            Text(cell)
                                .foregroundColor(buttonColor(cell))
                                .font(.system(size: 40, weight: .bold))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(buttonBackgroundColor(cell))
                                .cornerRadius(15)
                        })
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text(visibleWorkings),
                dismissButton: .default(Text("Okay"))
            )
        }
    }
    
    // Button text color based on the button type
    func buttonColor(_ cell: String) -> Color {
        if cell == "AC" || cell == "⌦" {
            return .white
        }
        
        if cell == "=" {
            return .white
        }
        
        if operators.contains(cell) {
            return .white
        }
        
        return .white
    }
    
    // Button background color based on the button type
    func buttonBackgroundColor(_ cell: String) -> Color {
        if cell == "AC" || cell == "⌦" {
            return Color.red.opacity(0.8) // Red with opacity for elegance
        }
        
        if cell == "=" {
            return Color.green.opacity(0.8) // A classy green for the result button
        }
        
        if operators.contains(cell) {
            return Color.orange.opacity(0.8) // Operators with a soft orange hue
        }
        
        return Color.gray.opacity(0.2) // Light gray for number buttons
    }
    
    // Handle button presses
    func buttonPressed(cell: String) {
        switch cell {
        case "AC":
            visibleWorkings = ""
            visibleResults = ""
        case "⌦":
            visibleWorkings = String(visibleWorkings.dropLast())
        case "=":
            visibleResults = calculateResults()
        case "-":
            addMinus()
        case "X", "/", "%", "+":
            addOperator(cell)
        default:
            visibleWorkings += cell
        }
    }
    
    // Add operator to the workings string
    func addOperator(_ cell: String) {
        if !visibleWorkings.isEmpty {
            let last = String(visibleWorkings.last!)
            if operators.contains(last) {
                visibleWorkings.removeLast()
            }
            visibleWorkings += cell
        }
    }
    
    // Add a minus sign
    func addMinus() {
        if visibleWorkings.isEmpty || visibleWorkings.last! != "-" {
            visibleWorkings += "-"
        }
    }
    
    // Calculate the result
    func calculateResults() -> String {
        if validInput() {
            var workings = visibleWorkings.replacingOccurrences(of: "%", with: "*0.01")
            workings = workings.replacingOccurrences(of: "X", with: "*")
            let expression = NSExpression(format: workings)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            return formatResult(val: result)
        }
        showAlert = true
        return ""
    }
    
    // Validate input
    func validInput() -> Bool {
        if visibleWorkings.isEmpty {
            return false
        }
        let last = String(visibleWorkings.last!)
        
        if operators.contains(last) || last == "-" {
            if last != "%" || visibleWorkings.count == 1 {
                return false
            }
        }
        
        return true
    }
    
    // Format the result to show up to two decimal places
    func formatResult(val: Double) -> String {
        if val.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", val)
        }
        
        return String(format: "%.2f", val)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

