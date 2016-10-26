namespace  Aphelion {
    /*
    *   File filter for file dialog
    */
    public class FileDialogFilter : Object {
        /*
        *   Filter caption
        */
        public string Caption { get; private set; }

        /*
        *   File filter mask
        */
        public string Filter { get; private set; }

        /*
        *   Constructor
        */
        public FileDialogFilter (string caption, string filter) {
            this.Caption = caption;
            this.Filter = filter;
        }
    }
}