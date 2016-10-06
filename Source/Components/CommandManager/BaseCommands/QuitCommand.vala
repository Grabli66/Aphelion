namespace  Aphelion {
    /*
    *   Quit command 
    */
    public class QuitCommand : Component {
        /*
        *   Run command
        */        
        private Message? Run (Type sender, Message data) {
            GLib.Timeout.add (100, () => {
                Gtk.main_quit ();
                return true;
            });

            return null; 
        }

        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages            
            dispatcher.Register (this, typeof (RunCommandMessage), Run);
        }

        /*
        *   Install command
        */
        public override async void Install () {
            var thisType = this.get_type ();
            yield MessageDispatcher.GetInstance ().Send (thisType, typeof (CommandManager), new RegisterCommandMessage (thisType));
            // Todo bind from settings
            yield MessageDispatcher.GetInstance ().Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(24, true), thisType));
        }
    }   
}