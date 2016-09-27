namespace  Aphelion {
    /*
    *   Keyboard shortcut
    */
    public class Shortcut : Object, Gee.Hashable<Shortcut> {
        public const string CTRL_MODIFICATOR = "ctrl";
        public const string SHIFT_MODIFICATOR = "shift";
        public const string ALT_MODIFICATOR = "alt";

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
        *   Return hash code
        */
        public static uint CalcHash (int keyCode, bool isCtrl = false, bool isShift = false, bool isAlt = false) {
            return str_hash (@"$(keyCode)$(isCtrl)$(isShift)$(isAlt)");
        }

        /*
        *   Constructor
        */
        public Shortcut (int keyCode, bool isCtrl = false, bool isShift = false, bool isAlt = false) {
            KeyCode = keyCode;
            IsCtrl = isCtrl;
            IsShift = isShift;
            IsAlt = isAlt;
        }

        /*
        *   Return hash code
        */
        public uint hash () {
            return CalcHash (KeyCode, IsCtrl, IsShift, IsAlt);
        }

        /*
        *   Compare object
        */
        public bool equal_to (Shortcut some) {
            return hash () == some.hash ();
        }
    }   
}