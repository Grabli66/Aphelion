namespace  Aphelion {
    /*
    *   Open file message
    */
    public class OpenFileMessage : Message {
        /*
        *   Full file name with path 
        */        
        public string FilePath { get; private set; }

        /*
        *   Constructor
        */
        public OpenFileMessage (string filePath) {
            this.FilePath = filePath;
        }

        /*
        *   Return log message
        */
        public override string ToLog () {
            return @"OpenFileMessage : { FilePath : $FilePath }";
        }
    }
}