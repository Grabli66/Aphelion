namespace  Aphelion {

    /*
    *   Delegate call when event emitted
    */
    internal delegate void EventCall (EventData event);

    /*
    *   To box delegate for generic
    */
    internal class DelegateBox : Object {
        public EventCall Call { get; private set; }

        public DelegateBox (EventCall call) {
            Call = call;
        }
    }

    /*
    *   Dispatch all events
    */    
    internal class EventDispatcher {
        /*
        *   Subscribes
        */
        public static Gee.HashMap<string, Gee.ArrayList<DelegateBox>?> _subscribes;

        /*
        *   Init static
        */
        private static inline void InitStatic () {
            if (_subscribes == null) _subscribes = new Gee.HashMap<string, Gee.ArrayList<DelegateBox>?>();
        }

        /*
        *   Subscribe on event
        */
        public static void Subscribe (Type type, EventCall call) {
            InitStatic ();

            var eventId = type.name ();

            var list = _subscribes[eventId];
            if (list == null) {
                list = new Gee.ArrayList<DelegateBox>();
                _subscribes[eventId] = list;
            }            
            
            list.add (new DelegateBox (call));
        }

        /*
        *   Emit events
        */
        public static void Emit (EventData data) {
            InitStatic ();

            var eventId = data.get_type ().name ();

            var list = _subscribes[eventId];            
            if (list == null) return;

            foreach (var item in list) {
                item.Call (data);
            }
        }
    }
}