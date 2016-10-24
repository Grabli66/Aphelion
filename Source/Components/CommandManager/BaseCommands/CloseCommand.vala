namespace  Aphelion {
    /*
    *   Close command 
    */
    public class CloseCommand : Component {
        /*
        *   Command name
        */  
        private const string NAME = "Close document";

        /*
        *   Command description
        */  
        private const string DESCRIPTION = "Close document";

        /*
        *   Run internal
        */
        private async void RunInternal () {
            yield MessageDispatcher.SendBroadcast (this.get_type (), new CloseMessage ());
        }

        /*
        *   Run command
        */        
        private Message? Run (Type sender, Message data) {
            RunInternal.begin ();
            return null; 
        }

        /*
        *   Create component items
        */
        public override void Init () {
            // Register messages            
            MessageDispatcher.Register (this, typeof (RunCommandMessage), Run);
        }

        /*
        *   Install command
        */
        public override async void Install () {
            var thisType = this.get_type ();
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), 
                                    new RegisterCommandMessage (new CommandInfo (thisType, NAME, DESCRIPTION)));
            // Todo bind from settings
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(25, true), thisType));
        }
    }   
}