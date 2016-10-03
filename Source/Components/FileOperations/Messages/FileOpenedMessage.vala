namespace  Aphelion {
    /*
    *   Request for open file
    */
    public class FileOpenedMessage : Message {   
        /*
        *   Saved content
        */
        public FileContent Content { get; private set; }

        /*
        *   Constructor
        */
        public FileOpenedMessage (FileContent content) {
            this.Content = content;
        }        
    }
}