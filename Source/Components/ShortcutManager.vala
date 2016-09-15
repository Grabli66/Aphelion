namespace Aphelion {
    /*
    *   Keyboard shortcut like Ctrl+Alt+Del
    */
    public class Shortcut : Object {
        public const string CTRL_MODIFICATOR = "ctrl";
        public const string SHIFT_MODIFICATOR = "shift";
        public const string ALT_MODIFICATOR = "alt";

        /*
        *   Key to code dictionary
        */
        private static Gee.HashMap<string, int?> _keyToCode;

        /*
        *   Code to key dictionary
        */
        private static Gee.HashMap<int, string> _codeToKey;

        /*
        *   Create key codes
        */
        private static void InitKeyCodes () {
            if (_keyToCode != null) return;
            if (_codeToKey != null) return;

            // TODO: better key support

            _keyToCode = new Gee.HashMap<string, int?> ();             
            _keyToCode["o"] = 32;
            _keyToCode["s"] = 39;
            _keyToCode["ctrl"] = 37;

            _codeToKey = new Gee.HashMap<int, string> ();
            _codeToKey[32] = "o";
            _codeToKey[39] = "s";  
            _codeToKey[37] = "ctrl";         
        }

        /*
        *   Action to run
        */
        public Action RunAction { get; private set; }

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
        *   Convert shortcut info to string
        */
        public static string ConvertToString (int keyCode, bool isCtrl, bool isShift, bool isAlt) {
            InitKeyCodes ();

            var sb = new StringBuilder ();
            if (isCtrl) {
                sb.append (CTRL_MODIFICATOR);
                sb.append ("+");
            }

            if (isShift) {
                sb.append (SHIFT_MODIFICATOR);
                sb.append ("+");
            }

            if (isAlt) {
                sb.append (ALT_MODIFICATOR);
                sb.append ("+");
            }            

            var key = _codeToKey[keyCode];
            if (key == null) throw new AphelionErrors.Common ("Unknown key code");
            sb.append (key);
            return sb.str;
        }


        /*
        *   Convert event to string
        */
        public static string EventToString (Gdk.EventKey e) {
            var isCtrl = (e.state & Gdk.ModifierType.CONTROL_MASK) > 0;
            var isShift = (e.state & Gdk.ModifierType.SHIFT_MASK) > 0;
            var isAlt = (e.state & Gdk.ModifierType.MOD1_MASK) > 0;
            return ConvertToString (e.hardware_keycode, isCtrl, isShift, isAlt);
        }

        /*
        *   Constructor
        */
        public Shortcut (Action action,
                         int keycode, 
                         bool isCtrl = false, 
                         bool isShift = false,
                         bool isAlt = false) {

            RunAction = action;
            KeyCode = keycode;
            IsCtrl = isCtrl;
            IsShift = isShift;
            IsAlt = isAlt;
        }        

        /*
        *   Constructor from Gdk.EventKey
        */
        public Shortcut.FromString (string s, Action action) {
            InitKeyCodes ();

            var downString = s.down ();

            var items = downString.split ("+");
            if (items.length < 1) throw new AphelionErrors.Common ("Wrong shortcut string");
            var key = items[items.length - 1];
            var code = _keyToCode[key];
            if (code == null) throw new AphelionErrors.Common ("Unknown key");

            var isCtrl = false;
            var isShift = false;
            var isAlt = false;
            if (items.length > 1) {
                for (int i = 0; i < items.length - 1; i++) {
                    var modif = items[i].down ();
                    if (modif == CTRL_MODIFICATOR) {
                        isCtrl = true;
                    } else if (modif == SHIFT_MODIFICATOR) {
                        isShift = true;
                    } else if (modif == ALT_MODIFICATOR) {
                        isAlt = true;
                    }
                }
            }

            this (action, code, isCtrl, isShift, isAlt);           
        }

        /*
        *   Return shortcut as string like Ctrl+A 
        */
        public string AsString () throws AphelionErrors.Common {
            return ConvertToString (KeyCode, IsCtrl, IsShift, IsAlt);
        }
    }

    /*
    *   Manage shortcuts
    */
    internal class ShortcutManager : Component {
        public const string DEFAULT_ID = "ShortcutManager";

        /*
        *   Known shortcuts. Key - shortcut as string. Value - shortcut
        */
        private Gee.HashMap<string, Shortcut?> _shortcuts = new Gee.HashMap<string, Shortcut?> ();        

        /*
        *   Constructor
        */
        public ShortcutManager (string name = DEFAULT_ID) {
            base (name);                                    
        }

        /*
        *   Bind to keyboard events
        */
        public override void OnPostInit () {
            var mainWindow = ComponentManagerHelper.GetMainWindowWidget ();

            mainWindow.key_press_event.connect ((e) => {
                stderr.printf (e.hardware_keycode.to_string ());                
                var shortcutString = Shortcut.EventToString (e);
                try {                    
                    var cacheShortcut = _shortcuts[shortcutString];
                    if (cacheShortcut != null) {
                        // Emit short cut event
                        stderr.printf (shortcutString);                        
                        cacheShortcut.RunAction.Run ();
                    }
                } catch (Error e) {
                    // TODO: send exception event
                    stderr.printf (e.message);
                }
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