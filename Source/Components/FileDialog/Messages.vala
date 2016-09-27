namespace  Aphelion {
    /*
    *   Request for open file
    */
    public class OpenFileMessage : Message {        
    }

    /*
    *   One or more files opened
    */
    public class FilesOpenedMessage : Message {
        /*
        *   Opened files with content
        */
        public TextFileContent[] Files { get; private set; }

        /*
        *   Constructor
        */
        public FilesOpenedMessage (TextFileContent[] files) {
            this.Files = files;
        }        
    }    
}