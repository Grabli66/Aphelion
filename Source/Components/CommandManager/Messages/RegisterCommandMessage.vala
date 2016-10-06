namespace  Aphelion {
    /*
    *   Register command
    */
    public class RegisterCommandMessage : Message {
        /*
        *   Command to register
        */
        public Type Command { get; private set; }

        /*
        *   Constructor
        */
        public RegisterCommandMessage (Type command) {
            this.Command = command;
        }
    }
}