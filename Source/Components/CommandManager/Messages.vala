namespace  Aphelion {
    /*
    *   Request for add command
    */
    public class AddCommandMessage : Message {
        public ICommand Command { get; private set; }

        /*
        *   Constructor
        */        
        public AddCommandMessage (ICommand command) {
            this.Command = command;
        }
    }   
}