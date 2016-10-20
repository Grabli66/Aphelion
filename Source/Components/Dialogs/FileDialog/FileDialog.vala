namespace  Aphelion {
    /*
    *   Dialog for open/save file
    */
    public class FileDialog : Object, IDialog {
        public const string OPEN_FILE_NAME = "Open File";
        public const string SAVE_FILE_NAME = "Save File";
        public const string SAVE_AS_FILE_NAME = "Save As File";

        /*
        *   Main window
        */
        private Gtk.Window _mainWindow { get; private set; }

        /*
        *   Dialog operation: open, save
        */
        private FileDialogOperation Operation { get; private set; }

        /*
        *   Show open file dialog
        */
        private Message? OpenFile () {
            var fileChooser = new Gtk.FileChooserDialog (OPEN_FILE_NAME, _mainWindow,
                                      Gtk.FileChooserAction.OPEN, 
                                      "_Cancel",
				                      Gtk.ResponseType.CANCEL,
				                      "_Open",
				                      Gtk.ResponseType.ACCEPT);            
                                    
            fileChooser.window_position = Gtk.WindowPosition.CENTER;
            fileChooser.set_transient_for (_mainWindow);
            
            // TODO: filter from message
            var filter = new Gtk.FileFilter ();
	        filter.set_filter_name ("Vala source");
	        filter.add_pattern ("*.vala");
            fileChooser.add_filter (filter);

            Message? res = null;

            if (fileChooser.run () == Gtk.ResponseType.ACCEPT) {
                var filePath = fileChooser.get_filename ();                
                res = new ReturnFilePathMessage (filePath, FileDialogOperation.OPEN);
            }   

            fileChooser.destroy ();
            return res;
        }

        /*
        *   Show save as dialog
        */
        private Message? SaveFile () {
            var fileChooser = new Gtk.FileChooserDialog (SAVE_AS_FILE_NAME, _mainWindow,
                                      Gtk.FileChooserAction.SAVE, 
                                      "_Cancel",
				                      Gtk.ResponseType.CANCEL,
				                      "_Save",
				                      Gtk.ResponseType.ACCEPT);
            
            fileChooser.window_position = Gtk.WindowPosition.CENTER;
            fileChooser.set_transient_for (_mainWindow);

            // TODO: filter from content
            var filter = new Gtk.FileFilter ();
	        filter.set_filter_name ("Vala source");
	        filter.add_pattern ("*.vala");
            fileChooser.add_filter (filter);

            Message? res = null;

            if (fileChooser.run () == Gtk.ResponseType.ACCEPT) {
                var filePath = fileChooser.get_filename ();                   
                res = new ReturnFilePathMessage (filePath, FileDialogOperation.SAVE);                                                                                        
            }   

            fileChooser.destroy ();
            return res;            
        }

        /*
        *   Constructor
        */
        public FileDialog (Gtk.Window mainWindow, FileDialogOperation operation) {
            this._mainWindow = mainWindow;
            this.Operation = operation;
        }

        /*
        *   Show dialog and return message
        */
        public Message? ShowWithResult () {
            switch (Operation) {
                case FileDialogOperation.OPEN:
                    return OpenFile (); 
                    break;
                case FileDialogOperation.SAVE:
                    return SaveFile ();
                    break;
            default:
                break;
            }

            return null;
        }
    }
}