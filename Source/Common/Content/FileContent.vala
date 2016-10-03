namespace Aphelion {
    /*
    *   File content
    */
    public class FileContent : Content {
        /*
        *   Name of file
        */
        public string FileName { get; private set; }

        /*
        *   Full file path with name
        */
        public string FilePath { get; private set; }

        /*
        *   Constructor
        */
        public FileContent (string id, string filePath, string data) {
            base (id, data);
            var file = File.new_for_path (filePath);
            FileName = file.get_basename ();            
            FilePath = filePath;
        }
    }
}