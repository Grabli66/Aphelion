namespace Aphelion {
    /*
    *   Text content
    */
    public class TextContent : Object, IContent {
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