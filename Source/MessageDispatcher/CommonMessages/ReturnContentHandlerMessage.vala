namespace  Aphelion {
    /*
    *   Return file content handler
    */
    public class ReturnContentHandlerMessage : Message {
        /*
        *   Content handler
        */
        public Type Handler { get; private set; }

        /*
        *   Constructor
        */
        public ReturnContentHandlerMessage (Type handler) {
            Handler = handler;
        }
    }
}