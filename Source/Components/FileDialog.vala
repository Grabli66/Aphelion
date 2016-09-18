namespace Aphelion {
    /*
    *   Open/save files 
    */
    public class FileDialog : Component {
        public const string DEFAULT_ID = "FileDialog";

        public const string OPEN_FILE_NAME = "Open File";
        public const string SAVE_FILE_NAME = "Save File";

        /*
        *   Constructor
        */
        public FileDialog (string name = DEFAULT_ID) {
            base (name);                                    
        }

        /*
        *   Show dialog for open file
        */
        public TextFileData? ShowOpen () {
            TextFileData res = null;

            var mainWindow = ComponentManagerHelper.GetMainWindowWidget ();

            var fileChooser = new Gtk.FileChooserDialog (OPEN_FILE_NAME, mainWindow,
                                      Gtk.FileChooserAction.OPEN, 
                                      "_Cancel",
				                      Gtk.ResponseType.CANCEL,
				                      "_Open",
				                      Gtk.ResponseType.ACCEPT);            
                                    
            fileChooser.set_transient_for (mainWindow);
            
            var filter = new Gtk.FileFilter ();
	        filter.set_filter_name ("Vala source");
	        filter.add_pattern ("*.vala");
            fileChooser.add_filter (filter);

            if (fileChooser.run () == Gtk.ResponseType.ACCEPT) {
                var filePath = fileChooser.get_filename ();
                stderr.printf (filePath);
                string data;
                size_t size;
                FileUtils.get_contents (filePath, out data, out size);                
                res = new TextFileData.FromFilePath (filePath, data);
                fileChooser.destroy ();
            }                        
            return res;
        }

        /*
        *   Show dialog for save file
        */
        public void ShowSave () {
            var mainWindow = ComponentManagerHelper.GetMainWindowWidget ();

            var fileChooser = new Gtk.FileChooserDialog (SAVE_FILE_NAME, mainWindow,
                                      Gtk.FileChooserAction.SAVE, "Save", "Cancel");

            fileChooser.set_transient_for (mainWindow);
            if (fileChooser.run () == Gtk.ResponseType.ACCEPT) {
                var fileName = fileChooser.get_filename ();                    
            }
            fileChooser.destroy ();
        }        
    }
}