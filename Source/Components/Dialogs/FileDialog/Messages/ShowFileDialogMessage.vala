namespace  Aphelion {
    /*
    *   Request for show dialog
    */
    public class ShowFileDialogMessage : Message {
        /*
        *   Filters for dialog
        */
        private Gee.ArrayList<FileDialogFilter> _filters;

        /*
        *   Dialog operation
        */
        public FileDialogOperation Operation { get; private set; }        

        /*
        *   Filters for dialog
        */
        public FileDialogFilter[] Filters { 
            owned get {
                return _filters.to_array ();
            } 
        }

        /*
        * Constructor
        */
        public ShowFileDialogMessage (FileDialogOperation operation) {
            this.Operation = operation; 
            _filters = new Gee.ArrayList<FileDialogFilter> ();
        }

        /*
        *   Add filter
        */
        public ShowFileDialogMessage AddFilter (string caption, string filter) {
            _filters.add (new FileDialogFilter (caption, filter));
            return this;
        }
    }
}