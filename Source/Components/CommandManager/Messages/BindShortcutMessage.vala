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
    }
}