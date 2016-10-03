namespace  Aphelion {
    /*
    *   Request for open file
    */
    public class FileSavedMessage : Message {   
        /*
        *   Saved content
        */
        public FileContent Content { get; private set; }

        /*
        *   Constructor
        */
        public FileSavedMessage (FileContent content) {
            this.Content = content;
        }        
    }
}