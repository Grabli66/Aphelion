namespace  Aphelion {
    /*
    *   Register command
    */
    public class RegisterCommandMessage : Message {
        /*
        *   Command to register
        */
        public CommandInfo CommandInfo { get; private set; }        

        /*
        *   Constructor
        */
        public RegisterCommandMessage (CommandInfo command) {
            this.CommandInfo = command;
        }
    }
}