namespace  Aphelion {
    /*
    *   Get command array
    */
    public class ReturnCommandsMessage : Message {    
        /*
        *   Command array
        */        
        public CommandInfo[] Commands { get; private set; }

        /*
        *   Constructor
        */
        public ReturnCommandsMessage (CommandInfo[] commands) {
            this.Commands = commands;
        } 

        /*
        *   Return log message
        */
        public override string ToLog () {
            return @"ReturnCommandsMessage : { Count: $(Commands.length) }";
        }                     
    }
}