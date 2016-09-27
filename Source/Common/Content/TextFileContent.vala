namespace Aphelion {
    /*
    *   File info and data
    */
    public class TextFileContent : TextContent {
        /*
        *   Name of file
        */
        public string FileName { get; private set; }

        /*
        *   Full path of file
        */
        public string FilePath { get; private set; }        

        /*
        *   Constructor
        */        
        public TextFileContent (string filePath, string content) {
            base (content);
            // TODO better 
            FileName = "";
            var parts = filePath.split ("/");
            if (parts.length > 0) {
                FileName = parts[parts.length - 1];
            }
            FilePath = filePath;            
        }        
    }
}