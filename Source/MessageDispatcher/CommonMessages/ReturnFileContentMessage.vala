namespace  Aphelion {
    /*
    *   Return file content
    */
    public class ReturnFileContentMessage : Message {
        /*
        *   Content
        */
        public Content Content { get; private set; }

        /*
        *   Constructor
        */
        public ReturnFileContentMessage (Content content) {
            this.Content = content;
        }
    }
}