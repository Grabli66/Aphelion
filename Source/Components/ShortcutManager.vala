namespace Aphelion {
    /*
    *   Keyboard shortcut like Ctrl+Alt+Del
    */
    internal class Shortcut {
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
        public Shortcut (int keycode, bool isCtrl = false, 
                                      bool isShift = false,
                                      bool isAlt = false) {
            KeyCode = keycode;
            IsCtrl = isCtrl;
            IsShift = isShift;
            IsAlt = isCtrl;
        }

        /*
        *   Constructor from Gdk.EventKey
        */
        public Shortcut.FromEventKey (Gdk.EventKey e) {
            var isCtrl = e.state == Gdk.ModifierType.CONTROL_MASK;
            var isShift = e.state == Gdk.ModifierType.SHIFT_MASK;
            var isAlt = e.state == Gdk.ModifierType.MOD1_MASK;
            this (e.hardware_keycode, isCtrl, isShift, isAlt);
        }

        /*
        *   Return shortcut as string like Ctrl+A 
        */
        public string AsString () {
            return "";
        }
    }

    /*
    *   Shortcut event
    */
    internal class ShortcutEvent : EventData {
        public Shortcut Shortcut { get; private set;}

        /*
        *   Constructor
        */
        public ShortcutEvent (Shortcut shortcut) {
            this.Shortcut = shortcut;
        }
    }

    /*
    *   Manage shortcuts
    */
    internal class ShortcutManager : Component {
        /*
        *   Known shortcuts. Key - shortcut as string. Value - shortcut
        */
        private Gee.HashMap<string, Shortcut> _shortcuts = new Gee.HashMap<string, Shortcut> ();        

        /*
        *   Bind to keyboard events
        */
        public override void OnPostInit () {
            var mainWindow = ComponentManagerHelper.GetMainWindowWidget ();

            mainWindow.key_press_event.connect ((e) => {
                stderr.printf (e.hardware_keycode.to_string ());                
                var shortcut = new Shortcut.FromEventKey (e);
                // Emit short cut event
                EventDispatcher.Emit (new ShortcutEvent(shortcut));
                return false;
            });
        }

        /*
        *   Add shortcut
        */
        public void Add (Shortcut shortcut) {
            _shortcuts[shortcut.AsString ()] = shortcut;
        }
    }    
}