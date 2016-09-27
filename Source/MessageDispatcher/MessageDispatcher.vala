namespace  Aphelion {
    /*
    *   Dispatch all events
    */    
    public class MessageDispatcher : Object {
        /*
        *   EventDispatcher instance
        */
        private static MessageDispatcher _instance;

        /*
        *   Registered recepients. MessageType -> (Recepient -> IMessageRecepient)
        */
        public Gee.HashMap<string,  Gee.HashMap<string, IMessageRecepient>?> _registeredMessages;

        /*
        *   Return instalce
        */
        public static inline MessageDispatcher GetInstance () {
            if (_instance == null) _instance = new MessageDispatcher ();
            return _instance;
        }

        /*
        *   Log message send
        */
        private void LogMessage (Object sender, Type destination, Message message, int64 delta) {
            var snd = sender.get_type ().name ();
            var dst = destination.name ();
            var mes = message.get_type ().name ();
            stderr.printf (@"$snd $dst $mes $delta (microseconds) \n");
        }

        /*
        *   Constructor
        */
        private MessageDispatcher () {
            _registeredMessages = new Gee.HashMap<string, Gee.HashMap<string, IMessageRecepient?>?> ();
        }        
       
        /*
        *   Register message
        */
        public void Register (Type messageType, IMessageRecepient recepient) {            
            var addr = recepient.get_type ().name ();
            var mess = messageType.name ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];

            // Create recepient map
            if (recepientMap == null) {
                recepientMap = new Gee.HashMap<string, IMessageRecepient?> ();
                _registeredMessages[mess] = recepientMap;
            }

            // add recepient by address
            recepientMap[addr] = recepient;            
        }

        /*
        *   Send message to recepient
        */
        public void Send (Object sender, Type destination, Message message) {            
            var dest = destination.name ();
            var mess = message.get_type ().name ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];
            if (recepientMap == null) {
                // TODO debug
                stderr.printf (@"$mess not found");
                return;
            }

            var recepient = recepientMap[dest];
            if (recepient == null) {
                // TODO debug
                return;
            }

            var start = get_real_time ();
            recepient.OnMessage (sender, message);
            var delta = get_real_time () - start;

            LogMessage (sender, destination, message, delta);            
        }

        /*
        *   Send message to all who can recieve it
        */
        public void SendBroadcast (Object sender, Message message) {            
            var mess = message.get_type ().name ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];
            if (recepientMap == null) {
                // TODO debug
                stderr.printf (@"$mess not found");
                return;
            }

            foreach (var rec in recepientMap.values) {                
                var start = get_real_time ();
                rec.OnMessage (sender, message);
                var delta = get_real_time () - start;
                LogMessage (sender, rec.get_type (), message, delta);
            }
        }        
    }
}