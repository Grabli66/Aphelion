namespace  Aphelion {
    /*
    *   Content saved message
    */
    public class ContentSavedMessage : Message {
        /*
        *   Saved content
        */
        public IContent Content { get; private set; }

        /*
        *   Constructor
        */
        public ContentSavedMessage (IContent content) {
            this.Content = content;
        }    
    }
}