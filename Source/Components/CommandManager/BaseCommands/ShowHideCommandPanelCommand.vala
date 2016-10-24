namespace  Aphelion {
    /*
    *   Command for something new 
    */
    public class ShowHideCommandPanelCommand : Component {
        /*
        *   Command name
        */  
        private const string NAME = "Show/hide command panel";

        /*
        *   Command description
        */  
        private const string DESCRIPTION = "Show/hide command panel";

        /*
        *   Run internal
        */
        private async void RunInternal () {
            yield MessageDispatcher.Send (this.get_type (), typeof (CommandPanel), new SwitchVisibilityMessage ());
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
            yield MessageDispatcher.Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(67), thisType));
        }
    }   
}