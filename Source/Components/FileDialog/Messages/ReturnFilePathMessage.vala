namespace  Aphelion {
    /*
    *   Return file path
    */
    public class ReturnFilePathMessage : Message {
        /*
        *   File path
        */
        public string FilePath { get; private set; }

        /*
        *   Operation
        */
        public DialogOperation Operation { get; private set; }

        /*
        *   Constructor
        */ 
        public ReturnFilePathMessage (string filePath, DialogOperation operation) {
            FilePath = filePath;
            Operation = operation;
        }
    }
}