namespace  Aphelion {
    /*
    *   Request for completion
    */
    public class GetCompletionMessage : Message {
        /*
        *   Source name
        */
        public string Name { get; private set; }

        /*
        *   Line in source
        */
        public int Line { get; private set; }

        /*
        *   Column in source
        */
        public int Column { get; private set; }

        /*
        *   Constructor
        */        
        public GetCompletionMessage (string name, int line, int column) {
            this.Name = name;
            this.Line = line;
            this.Column = column;            
        }
    }
}