namespace  Aphelion {
    /*
    *   File operation component
    */
    public class FileOperations : Component {
        /*
        *   Process SaveFileMessage
        */
        private Message? SaveFile (Type sender, Message data) {
            var messa = (SaveFileMessage) data;
            var content = messa.Content as FileContent;
            FileUtils.set_contents (content.FilePath, content.Content);                          
            return new FileSavedMessage (content);
        }

        /*
        *   Process OpenFileMessage
        */
        private Message? OpenFile (Type sender, Message data) {
            var messa = (OpenFileMessage) data;
            string dat;
            size_t size;
            FileUtils.get_contents (messa.FilePath, out dat, out size);
            var res = new FileContent (messa.FilePath, messa.FilePath, dat);            
            return new FileOpenedMessage (res);
        }

        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (this, typeof (SaveFileMessage), SaveFile); 
            dispatcher.Register (this, typeof (OpenFileMessage), OpenFile);
        }
    }
}