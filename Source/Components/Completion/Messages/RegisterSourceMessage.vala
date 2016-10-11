namespace  Aphelion {
    /*
    *   Register source
    */
    public class RegisterSourceMessage : Message {        
        /*
        *   Source data
        */
        public string Data { get; private set; }

        /*
        *   Constructor
        */        
        public RegisterSourceMessage (string data) {
            this.Data = data;            
        }
    }
}