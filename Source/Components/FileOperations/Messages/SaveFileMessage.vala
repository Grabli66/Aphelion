namespace  Aphelion {
    /*
    *   Save file message
    */
    public class SaveFileMessage : Message {
        /*
        *   Full file name with path 
        */        
        public FileContent Content { get; private set; }

        /*
        *   Constructor
        */
        public SaveFileMessage (FileContent content) {
            this.Content = content;
        }
    }
}