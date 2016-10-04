namespace  Aphelion {   
    /*
    *   Abstract request
    */
    public class BroadcastResponse : Object {
        /*
        *   Sender of message
        */
        public Type Sender { get; private set; }

        /*
        *   Message
        */
        public Message? Message { get; private set; }

        public BroadcastResponse (Type sender, Message? message) {
            this.Sender = sender;
            this.Message = message;
        }
    }    
}