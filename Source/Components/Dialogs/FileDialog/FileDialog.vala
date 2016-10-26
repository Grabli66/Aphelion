namespace  Aphelion {
    /*
    *   Dialog for open/save file
    */
    public class FileDialog : Object, IDialog {
        public const string ALL_FILES_CAPTION = "All files";
        public const string ALL_FILES_FILTER = "*.*";
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
        private FileDialogOperation _operation;

        /*
        *   File filters
        */
        private FileDialogFilter[] _filters;

        /*
        *   Add filters to dialog
        */
        private void AddFilters (Gtk.FileChooserDialog fileChooser) {
            if (_filters.length > 0) {
                foreach (var filt in _filters) {
                    var filter = new Gtk.FileFilter ();
                    filter.set_filter_name (filt.Caption);
                    filter.add_pattern (filt.Filter);
                    fileChooser.add_filter (filter);
                }                        
            } else {
                var filter = new Gtk.FileFilter ();
                filter.set_filter_name (ALL_FILES_CAPTION);
                filter.add_pattern (ALL_FILES_FILTER);
                fileChooser.add_filter (filter);
            }
        }

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
            AddFilters (fileChooser);

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
            AddFilters (fileChooser);

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
        public FileDialog (Gtk.Window mainWindow, ShowFileDialogMessage messa) {
            this._mainWindow = mainWindow;
            _operation = messa.Operation;
            _filters = messa.Filters;
        }

        /*
        *   Show dialog and return message
        */
        public Message? ShowWithResult () {
            switch (_operation) {
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