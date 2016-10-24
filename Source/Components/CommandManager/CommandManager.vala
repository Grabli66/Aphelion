namespace  Aphelion {
    /*
    *   Shortcut + Command
    */
    internal class CommandValue : Object {
        /*
        *   Command
        */
        public CommandInfo CommandInfo { get; private set; }

        /*
        *   Shortcut
        */
        public Shortcut Shortcut { get; private set; }

        /*
        *   Constructor
        */
        public CommandValue (CommandInfo commandInfo, Shortcut shortcut) {
            this.CommandInfo = commandInfo;
            this.Shortcut = shortcut;
        }
    }


    /*
    *   Manage commands
    */
    public class CommandManager : Component {
        /*
        *   Binded commands to shortcut
        */
        private Gee.HashMap<uint, CommandValue?> _bindedCommands = new Gee.HashMap<uint, CommandValue?> ();

        /*
        *   Registered commands
        */
        private Gee.HashMap<Type, CommandInfo> _registeredCommands = new Gee.HashMap<Type, CommandInfo> ();

        /*
        *   Process key press
        */
        private Message? KeyPress (Type sender, Message data) {
            var messa = (KeyPressMessage) data;
            var hash = Shortcut.CalcHash (messa.KeyCode, messa.IsCtrl, messa.IsShift, messa.IsAlt);
            var command = _bindedCommands[hash];
            if (command != null) {            
                MessageDispatcher.Send.begin (this.get_type (), command.CommandInfo.Command, new RunCommandMessage ());
            }
            return null;
        }

        /*
        *   Process RegisterCommandMessage
        */
        private Message? RegisterCommand (Type sender, Message data) {
            var messa = (RegisterCommandMessage) data;
            _registeredCommands[messa.CommandInfo.Command] = messa.CommandInfo;
            return null;
        }

        /*
        *   Process BindShortcutMessage
        */
        private Message? BindShortcut (Type sender, Message data) {
            var messa = (BindShortcutMessage) data;
            var commandInfo = _registeredCommands[messa.Command];
            if (commandInfo == null) return null;            
            _bindedCommands[messa.Shortcut.hash ()] = new CommandValue (commandInfo, messa.Shortcut);        
            return null;
        }

        /*
        *   Process GetCommandsMessage
        */
        private Message? ReturnCommands () {
            return new ReturnCommandsMessage (_registeredCommands.values.to_array ());
        }       

        /*
        *   Create component items
        */
        public override void Init () {            
            // Register messages
            MessageDispatcher.Register (this, typeof (KeyPressMessage), KeyPress);
            MessageDispatcher.Register (this, typeof (RegisterCommandMessage), RegisterCommand);
            MessageDispatcher.Register (this, typeof (BindShortcutMessage), BindShortcut);
            MessageDispatcher.Register (this, typeof (GetCommandsMessage), ReturnCommands);            
        }
    }
}