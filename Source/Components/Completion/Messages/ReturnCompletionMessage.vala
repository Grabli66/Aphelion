namespace  Aphelion {
    /*
    *   Return completion
    */
    public class ReturnCompletionMessage : Message {        

        /*
        *   Completions
        *   TODO: struct
        */
        public string[] Completions { get; private set; }

        /*
        *   Constructor
        */        
        public ReturnCompletionMessage (string[] completions) {
            this.Completions = completions;
        }         
    }
}