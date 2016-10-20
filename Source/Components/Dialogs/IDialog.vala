namespace  Aphelion {
    /*
    *   Dialog interface
    */
    public interface IDialog : Object {        
        /*
        *   Show dialog and return message
        */
        public abstract Message? ShowWithResult ();
    }
}