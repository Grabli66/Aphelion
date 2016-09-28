namespace  Aphelion {
    /*
    *   One or more files opened
    */
    public class SaveAsFileMessage : Message {
        /*
        *   Content to save
        */
        public IContent Content { get; private set; }

        /*
        *   Constructor
        */
        public SaveAsFileMessage (IContent content) {
            this.Content = content;
        }        
    } 
}