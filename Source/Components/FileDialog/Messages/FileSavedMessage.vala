namespace  Aphelion {
    /*
    *   Request for open file
    */
    public class FileSavedMessage : Message {   
        /*
        *   Saved content
        */
        public IContent Content { get; private set; }

        /*
        *   Constructor
        */
        public FileSavedMessage (IContent content) {
            this.Content = content;
        }        
    }
}