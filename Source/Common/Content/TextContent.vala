namespace Aphelion {
    /*
    *   Text content
    */
    public class TextContent : Object, IContent {
        /*
        *   Id of content
        */
        public string Id { get; set; }

        /*
        *   Content of text file
        */
        public string Content { get; private set; }

        /*
        *   Constructor
        */
        public TextContent (string content) {
            this.Content = content;
        }
    }
}