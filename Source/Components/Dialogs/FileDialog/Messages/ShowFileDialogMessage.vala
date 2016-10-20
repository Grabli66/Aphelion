namespace  Aphelion {
    /*
    *   Request for show dialog
    */
    public class ShowFileDialogMessage : Message {
        /*
        *   Dialog operation
        */
        public FileDialogOperation Operation { get; private set; }

        /*
        * Constructor
        */
        public ShowFileDialogMessage (FileDialogOperation operation) {
            this.Operation = operation;
        }
    }
}