namespace  Aphelion {
    /*
    *   Request for show dialog
    */
    public class ShowFileDialogMessage : Message {
        /*
        *   Dialog operation
        */
        public DialogOperation Operation { get; private set; }

        /*
        * Constructor
        */
        public ShowFileDialogMessage (DialogOperation operation) {
            this.Operation = operation;
        }
    }
}