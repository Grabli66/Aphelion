namespace Aphelion {
    /*
    *   Response for content request 
    */
    public class ContentResponseEvent : EventData {
        /*
        *   Component that send event
        */
        public IContentContainer Content { get; private set; }

        /*
        *   Constructor
        */
        public ContentResponseEvent (IContentContainer content) {
            this.Content = content;
        }        
    } 
}