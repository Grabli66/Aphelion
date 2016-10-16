namespace  Aphelion {
    /*
    *   Bind shortcut
    */
    public class BindShortcutMessage : Message {
        /*
        *   Shortcut to bind
        */
        public Shortcut Shortcut { get; private set; }

        /*
        *   Command to bind
        */
        public Type Command { get; private set; }

        /*
        *   Constructor
        */
        public BindShortcutMessage (Shortcut shortcut, Type command) {
            this.Shortcut = shortcut;
            this.Command = command;
        }

         /*
        *   Return log message
        */
        public override string ToLog () {
            var keyCode = Shortcut.KeyCode;
            var isCtrl = Shortcut.IsCtrl;
            var isShift = Shortcut.IsShift;
            var isAlt = Shortcut.IsAlt;
            return @"BindShortcutMessage : { KeyCode : $keyCode, IsCtrl : $isCtrl, IsShift : $isShift, IsAlt : $isAlt }";
        }
    }
}