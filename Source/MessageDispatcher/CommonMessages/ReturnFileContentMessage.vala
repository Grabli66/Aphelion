namespace  Aphelion {
    /*
    *   Return file content
    */
    public class ReturnFileContentMessage : Message {
        /*
        *   Content
        */
        public IContent Content { get; private set; }

        /*
        *   Constructor
        */
        public ReturnFileContentMessage (TextContent content) {
            this.Content = content;
        }
    }
}