namespace  Aphelion {
    /*
    *   Key press message
    */
    public class KeyPressMessage : Message {        
        /*
        *   Keyboard key
        */
        public int KeyCode { get; private set; }

        /*
        *   Is ctrl pressed
        */
        public bool IsCtrl { get; private set; }

        /*
        *   Is shift pressed
        */
        public bool IsShift { get; private set; }

        /*
        *   Is alt pressed
        */
        public bool IsAlt { get; private set; }

        /*
        *   Constructor
        */        
        public KeyPressMessage (int keyCode, bool isCtrl, bool isShift, bool isAlt) {            
            KeyCode = keyCode;
            IsCtrl = isCtrl;
            IsShift = isShift;
            IsAlt = isAlt;
        }
    }    
}