namespace  Aphelion {
    /*
    *   Delegate for get message
    */
    public delegate void OnMessageDelegate (Type sender, Message message);

    /*
    *   Dispatch all events
    */    
    public class MessageDispatcher : Object {
        /*
        *   EventDispatcher instance
        */
        private static MessageDispatcher _instance;

        /*
        *   Registered recepients. MessageType -> (Recepient -> RecepientData)
        */
        private Gee.HashMap<string,  Gee.HashMap<string, RecepientData>?> _registeredMessages;

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
        private void LogMessage (Type sender, Type destination, Message messa, int64 delta) {
            var snd = sender.name ();
            var dst = destination.name ();
            var mes = messa.get_type ().name ();
            message (@"$snd -> $dst $mes $delta (microseconds)");
        }

        /*
        *   Constructor
        */
        private MessageDispatcher () {
            _registeredMessages = new Gee.HashMap<string, Gee.HashMap<string, RecepientData?>?> ();
        }
        
        /*
        *   Sent to on message async
        */
        private async void OnMessageInternal (RecepientData recepient, Type sender, Message message) {
            var start = get_real_time ();
            recepient.OnMessage (sender, message);
            var delta = get_real_time () - start;
            LogMessage (sender, recepient.Recepient, message, delta);
        }

        /*
        *   Internal send
        */
        private void SendInternal (Type sender, Type destination, Message messa) {
            var dest = destination.name ();
            var mess = messa.get_type ().name ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];
            if (recepientMap == null) {                
                message (@"$mess not found");
                return;
            }

            var recepient = recepientMap[dest];
            if (recepient == null) {
                message (@"Recepient $dest not found");
                return;
            }
            
            OnMessageInternal.begin (recepient, sender, messa);                        
        } 

        /*
        *   Register message
        */
        public void Register (Object recepient, Type messageType, OnMessageDelegate onMessage) {
            var recType = recepient.get_type ();            
            var addr = recType.name ();
            var mess = messageType.name ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];

            // Create recepient map
            if (recepientMap == null) {
                recepientMap = new Gee.HashMap<string, RecepientData?> ();
                _registeredMessages[mess] = recepientMap;
            }

            // add recepient by address
            recepientMap[addr] = new RecepientData (recType, onMessage);            
        }

        /*
        *   Send message to recepient
        */
        public void Send (Type sender, Type destination, Message message) {
            Idle.add(() => {
                SendInternal (sender, destination, message);
                return false;
            });                        
        }

        /*
        *   Send message to all who can recieve it
        */
        public void SendBroadcast (Type sender, Message messa) {         
            var mess = messa.get_type ().name ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];
            if (recepientMap == null) {
                // TODO debug
                message (@"$mess not found");
                return;
            }

            foreach (var rec in recepientMap.values) {                                
                OnMessageInternal.begin (rec, sender, messa);
            }
        }        
    }
}