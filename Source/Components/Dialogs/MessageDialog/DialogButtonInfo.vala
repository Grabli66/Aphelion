namespace  Aphelion {
    /*
    *   Dialog button info
    */
    public class DialogButtonInfo {
        /*
        *   Button caption
        */
        public string Caption { get; private set; }

        /*
        *   Response code
        */
        public int Code { get; private set; }

        /*
        *   Constructor
        */
        public DialogButtonInfo (string caption, int code) {
            this.Caption = caption;
            this.Code = code;
        }
    }
}