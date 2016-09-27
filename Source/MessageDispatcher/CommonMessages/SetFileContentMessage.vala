namespace  Aphelion {
    /*
    *   Request for set file content
    */
    public class SetFileContentMessage : Message {
        /*
        *   Opened files with content
        */
        public TextFileContent[] Content { get; private set; }

        /*
        *   Constructor
        */
        public SetFileContentMessage (TextFileContent[] files) {
            this.Content = files;
        }    
    }
}