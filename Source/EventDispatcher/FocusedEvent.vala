namespace Aphelion {
    /*
    *   Event fired when component focused
    */
    public class FocusedEvent : EventData {
        /*
        *   Component that send event
        */
        public Component Sender { get; private set; }

        /*
        *   Constructor
        */
        public FocusedEvent (Component sender) {
            Sender = sender;
        }
        
        public void Shit () {
        	stderr.printf ("GOOD");
        }
    } 
}