namespace Aphelion {
    /*
    *   File info and data
    */
    public class TextFileData {
        /*
        *   Name of file
        */
        public string FileName { get; private set; }

        /*
        *   Full path of file
        */
        public string? FilePath { get; private set; }

        /*
        *   Content of text file
        */
        public string Content { get; private set; }

        /*
        *   Constructor
        */        
        public TextFileData.FromFilePath (string filePath, string content) {
            // TODO better 
            FileName = "";
            var parts = filePath.split ("/");
            if (parts.length > 0) {
                FileName = parts[parts.length - 1];
            }
            FilePath = filePath;
            Content = content;
        }

        /*
        *   Constructor
        */        
        public TextFileData.FromFileName (string fileName, string content) {
            // TODO better 
            FileName = fileName;            
            FilePath = null;
            Content = content;
        }
    }
}