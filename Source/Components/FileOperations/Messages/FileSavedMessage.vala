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

        /*
        *   Return log message
        */
        public override string ToLog () {
            return @"FileSavedMessage : { Id : $(Content.Id), FilePath : $(Content.FilePath) }";
        }     
    }
}