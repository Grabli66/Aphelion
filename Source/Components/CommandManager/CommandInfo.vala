namespace  Aphelion {
    /*
    *   Command info
    */
    public class CommandInfo : Object {
        /*
        *   Command type
        */
        public Type Command { get; private set; }

        /*
        *   Command name
        */
        public string Name { get; private set; }

        /*
        *   Command description
        */
        public string Description { get; private set; }

        /*
        *   Constructor
        */
        public CommandInfo (Type command, string name, string description) {
            this.Command = command;
            this.Name = name;
            this.Description = description;
        }
    }
}