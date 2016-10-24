namespace  Aphelion {
    /*
    *   Request for show dialog
    */
    public class ShowMessageDialogMessage : Message {
        /*
        *   Dialog message 
        */
        public string Message { get; private set; }        

        /*
        *   Buttons info
        */
        public Gee.ArrayList<DialogButtonInfo> Buttons { get; private set; }

        /*
        *   Constructor
        */
        public ShowMessageDialogMessage (string messa) {
            this.Message = messa;
            Buttons = new Gee.ArrayList<DialogButtonInfo> ();
        }

        /*
        *   Add button info
        */
        public ShowMessageDialogMessage AddButton (string caption, int code) {
            Buttons.add (new DialogButtonInfo (caption, code));
            return this;            
        }
    }
}