namespace  Aphelion {
    /*
    *   Close command 
    */
    public class CloseCommand : Component {  
        /*
        *   Run internal
        */
        private async void RunInternal () {
            yield MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new CloseMessage ());
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
            yield MessageDispatcher.GetInstance ().Send (thisType, typeof (CommandManager), new BindShortcutMessage (new Shortcut(25, true), thisType));
        }
    }   
}