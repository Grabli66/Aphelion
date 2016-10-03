namespace Aphelion {
    /*
    *   Content
    */
    public class Content : Object {
        /*
        *   Id of content
        */
        public string Id { get; private set; }

        /*
        *   Content
        */
        public string Content { get; private set; }

        //public string ContentType;

        /*
        *   Constructor
        */
        public Content (string id, string content) {
            this.Id = id;
            this.Content = content;
        }     
    }
}