namespace  Aphelion {
    /*
    *   Tabbed source editor
    */
    public class SourceEditor : Component {
        /*
        *   Width of tab
        */
        public const uint DEFAULT_TAB_WIDTH = 4;
        
        /*
        *   Margin from left
        */
        public const int LEFT_MARGIN = 20;

        /*
        *   Margin between lines
        */        
        public const int LINE_MARGIN = 3;

        /*
        *   Notebook widget
        */
        private Gtk.Notebook _notebook;  

        /*
        *   Known pages; Path -> SourcePage
        */
        private Gee.HashMap<string, SourcePage?> _pages = new Gee.HashMap<string, SourcePage?>(); 

        /*
        *   Source view that focused
        */
        private SourcePage? _focusedPage;

        /*
        *   Counter for temp page
        */
        private int _tempCounter = 1;

        /*
        *   Return self type
        */
        private void ReturnGetFileContentHandler (Object sender, GetFileContentHandlerMessage message) {
            MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new ReturnContentHandlerMessage (this.get_type ()));
        } 

        /*
        *   Return file content
        */
        private void ReturnGetFileContent (Object sender, GetFileContentMessage message) {
            if (_focusedPage == null) return;
            var content = _focusedPage.GetFileContent ();
            content.Id = _focusedPage.FilePath;
            MessageDispatcher.GetInstance ().Send (this, sender.get_type (), new ReturnFileContentMessage (content));
        }

        /*
        *   Set file content
        */
        private void SetFileContent (SetFileContentMessage message) {
            var content = message.Content;
            AddSource (content.FilePath, content.Content);
        }        

        /*
        *   On content saved
        */
        private void ContentSaved (FileSavedMessage message) {
            var page = _pages[message.Content.Id];            
            if (page == null) return;
            
            var content = message.Content as TextFileContent;
            if (content == null) return;                                        
            page.FilePath  = content.FilePath;
            if (page.IsTemp) {
                _pages.remove (message.Content.Id);
                _pages[page.FilePath] = page;
                _tempCounter--;
            }
            page.IsTemp = false;
            page.Changed  = false;                                                                   
        }

        /*
        *   Get temp file name
        */
        private string GetUntitledName () {
            return @"Untitled-$(_tempCounter).vala";
        }

        /*
        *   Add source
        */
        private void AddSource (string path, string data, bool isTemp = false) {
            var page = _pages[path];                        
            if (page != null) return;

            page = new SourcePage (path, data, isTemp, _notebook);

            if (isTemp) _tempCounter++;

            page.OnFocusIn.connect ((e) => {                
                _focusedPage = e;                
            });

            page.OnFocusOut.connect ((e) => {
                _focusedPage = null;
            });

            page.OnPageClose.connect ((e) => {
                RemovePage (e);
            });

            _pages[path] = page;
            _notebook.show_all ();            
        }

        /*
        *   Remove page
        */
        private void RemovePage (SourcePage page) {
            _pages.remove (page.FilePath);
            page.RemovePage ();
            _tempCounter--;
        }

        /*
        *   Process CloseMessage
        */
        private void ClosePage (CloseMessage data) {
            if (_focusedPage == null) return;
            RemovePage (_focusedPage);
        }

        /*
        *   Process new page
        */
        private void NewPage (NewMessage message) {            
            if (_focusedPage == null) return;            
            AddSource (GetUntitledName (), "", true);
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _notebook = new Gtk.Notebook ();
            AddSource (GetUntitledName (), "", true);

            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (typeof (GetFileContentHandlerMessage), this);
            dispatcher.Register (typeof (SetFileContentMessage), this);
            dispatcher.Register (typeof (GetFileContentMessage), this);
            dispatcher.Register (typeof (FileSavedMessage), this);
            dispatcher.Register (typeof (CloseMessage), this);
            dispatcher.Register (typeof (NewMessage), this);
        }

        /*
        *   Install component
        */
        public override void Install () {
            MessageDispatcher.GetInstance ().Send (this, typeof (Workspace), new PlaceWidgetMessage (_notebook));
        }

        /*
        *   On receive message
        */
        public override void OnMessage (Object sender, Message data) {
            if (data is GetFileContentHandlerMessage) ReturnGetFileContentHandler (sender, (GetFileContentHandlerMessage) data);            
            if (data is SetFileContentMessage) SetFileContent ((SetFileContentMessage)data);
            if (data is GetFileContentMessage) ReturnGetFileContent (sender, (GetFileContentMessage)data);
            if (data is FileSavedMessage) ContentSaved ((FileSavedMessage)data);
            if (data is CloseMessage) ClosePage ((CloseMessage)data);
            if (data is NewMessage) NewPage ((NewMessage)data);
        }
    }
}