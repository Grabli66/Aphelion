namespace Aphelion {
    /*
    *   Event for key press
    */
    internal class KeyPressEvent : EventData {
        /*
        *   Code for O key
        */
        public const int O_KEY = 32;

        /*
        *   Code for S key
        */
        public const int S_KEY = 39;

        /*
        *   Key kode
        */
        public int KeyCode { get; private set; }

        /*
        *   Is control key down
        */
        public bool ControlDown { get; private set; }

        /*
        *   Constructor
        */
        public KeyPressEvent (int keyCode, bool controlDown) {
            KeyCode = keyCode;
            ControlDown = controlDown;
        }
    }


    /*
    *   Process keyboard 
    */
    internal class Keyboard : Component {
        /*
        *   Call when component add
        */
        public override void OnEnter () {
            MainWindow.GetInstance ().key_press_event.connect ((e) => {
                stderr.printf (e.hardware_keycode.to_string ());
                EventDispatcher.Emit (new KeyPressEvent(e.hardware_keycode, e.state == Gdk.ModifierType.CONTROL_MASK));                
                return false;
            });
        }

        /*
        *   Call when component leave window
        */
        public override void OnLeave () {
        }
    }    
}