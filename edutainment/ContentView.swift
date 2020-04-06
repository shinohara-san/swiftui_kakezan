import SwiftUI

struct ContentView: View {
    @State private var gameOn = false
    @State private var table = 1
    @State private var selection = 1
    let questionArray = ["5", "10", "15", "All"]
    @State private var multiply = Int.random(in: 1...10)
    func numberOfQuestions() -> Int {
        switch selection {
        case 0:
            return Int(questionArray[0]) ?? 5
        case 1:
            return Int(questionArray[1]) ?? 5
        case 2:
            return Int(questionArray[2]) ?? 5
        case 3:
            return Int(questionArray[3]) ?? 20
        default:
            return 5
        }
    }
    
    @State var numOfQuestions = 5
    
    @State private var answer = ""
    @State private var score = 0
    @State private var showAlert = false
    
    //    @Environment(\.presentationMode) var presentationMode
    
    func nextQuestion(){
        answer = ""
        multiply = Int.random(in: 1 ... 10)
        numOfQuestions -= 1
        
        if numOfQuestions < 1 {
            self.showAlert = true
        }
    }
    
    
    var body: some View {
        NavigationView{
            VStack{
                Section{
                    Stepper(value: $table, in: 1...10) {
                        Text("だん : \(table)")
                    }.padding(.vertical, 30.0).padding()
                }
                .padding(.horizontal, 64)
                
                Section(header: Text("もんだいすう").foregroundColor(.black).font(.largeTitle)){
                    Picker(selection: $selection, label: Text("")) {
                        
                        ForEach(0 ..< self.questionArray.count) {
                            Text(self.questionArray[$0]).tag($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding([.leading, .bottom, .trailing], 20.0)
                }
                .sheet(isPresented: $gameOn){
                    VStack {
                        Text("もんだいすう: \(self.numOfQuestions) もん")
                        
                        HStack {
                            VStack{
                                //                            id:\.selfがないとイメージ表示されない
                                ForEach(0 ..< self.table, id:\.self){
                                    Image(String($0 + 1)).resizable().frame(width: 60, height: 60)
                                }
                            }
                            
                            Image(systemName: "pencil.slash")
                            
                            VStack{
                                ForEach(0 ..< self.multiply, id:\.self){
                                    Image(String($0 + 1)).resizable().frame(width: 60, height: 60)
                                }
                            }
                            
                        }
                        
                        TextField("Placeholder", text: self.$answer).textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .keyboardType(.numberPad)
                        
                        Button(action: {
                            
                            if self.answer == ""{
                                return
                            }
                            
                            if self.table * self.multiply == Int(self.answer){
                                self.score += 1
                                self.nextQuestion()
                            }else {
                                self.nextQuestion()
                            }
                        }) {
                            Text("つぎのもんだい").padding().background(Color.blue).foregroundColor(.white).cornerRadius(5)
                            
                        }.alert(isPresented: self.$showAlert){
                            Alert(title: Text("おわり"), message: Text("てんすう: \(self.score)てん"), dismissButton: .default(
                                Text("OK"), action: { self.gameOn = false }
                                )
                            )
                        } //アラートの場所気をつけて
                    }
                }
                
                Button(action: {
                    self.gameOn = true
                    self.numOfQuestions = self.numberOfQuestions()
                }) {
                    Text("はじめる")
                }.padding().background(Color.blue).foregroundColor(.white).cornerRadius(5)
                Spacer()
            }.navigationBarTitle(Text("えでゅていんめんと"), displayMode: .inline)
            
            
        }
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
