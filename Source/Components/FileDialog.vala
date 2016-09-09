using Gtk;

namespace Aphelion {
    /*
    *   File info and data
    */
    internal class TextFileData {
        /*
        *   Name of file
        */
        public string FileName { get; private set; }

        /*
        *   Full path of file
        */
        public string FilePath { get; private set; }

        /*
        *   Content of text file
        */
        public string Content { get; private set; }

        /*
        *   Constructor
        */        
        public TextFileData (string filePath, string content) {
            // TODO better 
            var parts = filePath.split ("/");
            FileName = parts[parts.length - 1];
            FilePath = filePath;
            Content = content;
        }
    }

    /*
    *   Open/save files 
    */
    internal class FileDialog : Component {
        public const string DEFAULT_ID = "FileDialog";

        public const string OPEN_FILE_NAME = "Open File";
        public const string SAVE_FILE_NAME = "Save File";


        public FileDialog (string name = DEFAULT_ID) {
            base (name);                        
        }        

        /*
        *   Call when component add
        */
        public override void OnEnter () {

        }

        /*
        *   Call when component leave window
        */
        public override void OnLeave () {

        }

        /*
        *   Show dialog for open file
        */
        public TextFileData ShowOpen () {
            var fileChooser = new FileChooserNative (OPEN_FILE_NAME, MainWindow.GetInstance (),
                                      FileChooserAction.OPEN, "Open", "Cancel");

            fileChooser.set_transient_for (MainWindow.GetInstance ());
            if (fileChooser.run () == ResponseType.ACCEPT) {
                var filePath = fileChooser.get_filename ();
                string data;
                size_t size;
                FileUtils.get_contents (filePath, out data, out size);
                return new TextFileData (filePath, data);                    
            }
            fileChooser.destroy ();
            return null;
        }

        /*
        *   Show dialog for save file
        */
        public void ShowSave () {
            var fileChooser = new FileChooserNative (SAVE_FILE_NAME, MainWindow.GetInstance (),
                                      FileChooserAction.SAVE, "Save", "Cancel");

            fileChooser.set_transient_for (MainWindow.GetInstance ());
            if (fileChooser.run () == ResponseType.ACCEPT) {
                var fileName = fileChooser.get_filename ();                    
            }
            fileChooser.destroy ();
        }        
    }
}