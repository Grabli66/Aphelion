namespace  Aphelion {
    /*
    *   Message direction
    */
    public enum MessageDirection {
        IN_DIRECTION,
        OUT_DIRECTION;
    }

    /*
    *   Dispatch all events
    */    
    public class MessageDispatcher : Object {        
        /*
        *   Registered recepients. MessageType -> (Recepient -> RecepientData)
        */
        private static Gee.HashMap<string,  Gee.HashMap<string, RecepientData>?> _registeredMessages;        

        /*
        *   Log message send
        */
        private static void LogMessage (MessageDirection direction, Type sender, Type destination, Message? messa, int64 delta) {
            var snd = sender.name ();
            var dst = destination.name ();
            var mesName = "null";
            if (messa != null) mesName = messa.ToLog ();            
            var dr = direction == MessageDirection.IN_DIRECTION ? "->" : "<-";
            message (@"$snd $dr $dst $mesName ($delta microseconds)");
        }

        /*
        *   Constructor
        */
        static construct {
            _registeredMessages = new Gee.HashMap<string, Gee.HashMap<string, RecepientData?>?> ();
        }
        
        /*
        *   Sent to on message async
        */
        private static async Message? OnMessageInternal (RecepientData recepient, Type sender, Message messa) {            
            var start = get_real_time ();
            var res = yield recepient.OnMessage.Run (sender, messa);
            var delta = get_real_time () - start;
            LogMessage (MessageDirection.IN_DIRECTION, sender, recepient.Recepient, messa, 0);
            LogMessage (MessageDirection.OUT_DIRECTION, sender, recepient.Recepient, res, delta);
            return res;
        }

        /*
        *   Internal send
        */
        private static async Message? SendInternal (Type sender, Type destination, Message messa) {            
            var dest = destination.name ();
            var mess = messa.get_type ().name ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];
            if (recepientMap == null) {                
                message (@"$mess not found");
                return null;
            }

            var recepient = recepientMap[dest];
            if (recepient == null) {
                message (@"Recepient $dest not found");
                return null;
            }
                        
            return yield OnMessageInternal (recepient, sender, messa);;                        
        } 

        /*
        *   Register message
        */
        public static void Register (Object recepient, Type messageType, OnMessageDelegate onMessage) {
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
            recepientMap[addr] = new RecepientData (recType, new AsyncMessageDelegate (onMessage));            
        }

        /*
        *   Send message to recepient
        */
        public static async Message Send (Type sender, Type destination, Message messa) {                       
            return yield SendInternal (sender, destination, messa);                                                            
        }

        /*
        *   Send message to all who can recieve it
        */
        public static async BroadcastResponse[] SendBroadcast (Type sender, Message messa) {                       
            var mess = messa.get_type ().name ();
            var arr = new Gee.ArrayList<BroadcastResponse> ();

            // get recepients by message type
            var recepientMap = _registeredMessages[mess];
            if (recepientMap == null) {
                // TODO debug
                message (@"$mess not found");
                return arr.to_array ();
            }            

            foreach (var rec in recepientMap.values) {                                
                var dat = yield OnMessageInternal (rec, sender, messa);
                arr.add (new BroadcastResponse (rec.Recepient, dat));                
            }

            return arr.to_array ();
        }        
    }
}