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
        *   Return self type
        */
        private Message? ReturnGetFileContentHandler (Type sender, Message data) {
            var message = (GetFileContentHandlerMessage) data;            
            return new ReturnContentHandlerMessage (this.get_type ());
        } 

        /*
        *   Return file content
        */
        private Message? ReturnGetFileContent (Type sender, Message data) {            
            if (_focusedPage == null) return null;
            var messa = (GetFileContentMessage) data;            
            if (messa.OnlyChanged && !_focusedPage.Changed) return null;            
            var content = _focusedPage.GetContent ();            
            return new ReturnFileContentMessage (content);
        }

        /*
        *   Set file content
        */
        private Message? SetFileContent (Type sender, Message data) {
            var message = (SetFileContentMessage) data;
            var content = message.Content;
            AddSource (content.FilePath, content.Content);
            return null;
        }        

        /*
        *   On content saved
        */
        private Message? ContentSaved (Type sender, Message data) {
            var message = (FileSavedMessage) data;
            var page = _pages[message.Content.Id];                       
            if (page == null) return null;
            
            var content = message.Content as FileContent;
            if (content == null) return null;                                        
            page.FilePath  = content.FilePath;            
            if (message.Content.Id != message.Content.FilePath) {
                _pages.remove (message.Content.Id);
                _pages[page.FilePath] = page;                
            }
            page.IsTemp = false;
            page.Changed  = false;
            return null;                                                                   
        }

        /*
        *   Get temp file name
        */
        private string GetUntitledName () {            
            var i = 0;
            while (true) {
                var key = @"Untitled-$(i).vala";
                if (i == 0) key = "Untitled.vala";                 
                if (!_pages.has_key (key)) return key;
                i++;                
            }                        
        }

        /*
        *   Add source
        */
        private void AddSource (string path, string data, bool isTemp = false) {
            var page = _pages[path];                        
            if (page != null) {
                message (@"Page $path exists");
                return;
            }

            page = new SourcePage (path, data, isTemp, _notebook);            

            page.OnFocusIn.connect ((e) => {                
                _focusedPage = e;                
            });

            page.OnFocusOut.connect ((e) => { 
                // TODO save page when show dialog
                //_focusedPage = null;
            });

            page.OnPageClose.connect ((e) => {
                RemovePage (e);
            });

            _pages[path] = page;
            var ind = _pages.size - 1;
            _notebook.show_all ();
            _notebook.set_current_page (ind);
        }

        /*
        *   Remove page with unsaved content
        */
        private async void RemoveUnsaved (SourcePage page) {
            var messa = (ReturnMessageDialogResultMessage) yield MessageDispatcher.Send (this.get_type (), typeof (Dialogs), 
                         new ShowMessageDialogMessage ("Do you want to save the changes?").
                         AddButton ("_Don't save", MessageDialogResult.CLOSE).                         
                         AddButton ("_Cancel", MessageDialogResult.CANCEL).
                         AddButton ("_Save", MessageDialogResult.OK));
            switch (messa.Result) {
                case MessageDialogResult.OK:                    
                    yield MessageDispatcher.Send (this.get_type (), typeof (SaveDocumentCommand), new RunCommandMessage ());                    
                    break;
                case MessageDialogResult.CANCEL:
                    break;
                case MessageDialogResult.CLOSE:
                    _pages.remove (page.FilePath);
                    page.RemovePage ();
                    break;
            default:
                break;
            }
        }

        /*
        *   Remove page
        */
        private void RemovePage (SourcePage page) {
            // Check for unsaved
            if (page.Changed) {                                 
                RemoveUnsaved.begin (page);
            } else {
                _pages.remove (page.FilePath);
                page.RemovePage ();
            }            
        }

        /*
        *   Process CloseMessage
        */
        private Message? ClosePage (Type sender, Message data) {
            if (_focusedPage == null) return null;            
            RemovePage (_focusedPage);
            return null;
        }

        /*
        *   Process new page
        */
        private Message? NewPage (Type sender, Message data) {
            AddSource (GetUntitledName (), "", true);
            return null;
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _notebook = new Gtk.Notebook ();
            AddSource (GetUntitledName (), "", true);

            // Register messages
            MessageDispatcher.Register (this, typeof (GetFileContentHandlerMessage), ReturnGetFileContentHandler);
            MessageDispatcher.Register (this, typeof (SetFileContentMessage), SetFileContent);
            MessageDispatcher.Register (this, typeof (GetFileContentMessage), ReturnGetFileContent);
            MessageDispatcher.Register (this, typeof (FileSavedMessage), ContentSaved);
            MessageDispatcher.Register (this, typeof (CloseMessage), ClosePage);
            MessageDispatcher.Register (this, typeof (NewMessage), NewPage);
        }

        /*
        *   Install component
        */
        public override async void Install () {
            MessageDispatcher.Send (this.get_type (), typeof (Workspace), new PlaceWidgetMessage (_notebook));
        }        
    }
}