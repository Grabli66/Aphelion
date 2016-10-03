namespace  Aphelion {
    /*
    *   Request for set file content
    */
    public class SetFileContentMessage : Message {
        /*
        *   Opened files with content
        */
        public FileContent Content { get; private set; }

        /*
        *   Constructor
        */
        public SetFileContentMessage (FileContent content) {
            this.Content = content;
        }    
    }
}