namespace  Aphelion {
    /*
    *   Async Message Delegate
    */
    public class AsyncMessageDelegate : Object {
        private OnMessageDelegate _onMessage;

        /*
        *   Constructor
        */
        public AsyncMessageDelegate (OnMessageDelegate onMessage) {
            _onMessage = onMessage;
        }

        /*
        *   Async run
        */
        public async Message? Run (Type sender, Message message) {
            return _onMessage (sender, message);
        }
    }    
}