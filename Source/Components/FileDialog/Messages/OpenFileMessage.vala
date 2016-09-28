namespace  Aphelion {
    /*
    *   One or more files opened
    */
    public class FileOpenedMessage : Message {
        /*
        *   Opened files with content
        */
        public TextFileContent File { get; private set; }

        /*
        *   Constructor
        */
        public FileOpenedMessage (TextFileContent file) {
            this.File = file;
        }        
    } 
}