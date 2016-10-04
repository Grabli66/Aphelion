namespace  Aphelion {
    /*
    *   Info of message recepient
    */
    internal class RecepientData {
        /*
        *   Recepient
        */
        public Type Recepient { get; private set; }

        /*
        *   Delegate for send message
        */
        public AsyncMessageDelegate OnMessage { get; private set; }

        public RecepientData (Type recepient, AsyncMessageDelegate onMessage) {
            Recepient = recepient;
            OnMessage = onMessage;
        }
    }
}