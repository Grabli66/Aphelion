namespace Aphelion {
    /*
    *   Page with content
    */
    public class SourcePage {
        /*
        *   Parent notebook
        */
        private Gtk.Notebook _notebook;

        /*
        *   Root widget for Notebook
        */
        private Gtk.ScrolledWindow _rootWidget;

        /*
        *   Caption label
        */
        private Gtk.Label _captionLabel;

        /*
        *   Close button
        */
        private Gtk.Button _closeButton;

        /*
        *   Close image icon
        */    
        private Gtk.Image _closeImage;

        /*
        *   Changed image
        */    
        private Gtk.Image _changedImage;

        /*
        *   Source buffer
        */
        private Gtk.SourceBuffer _buffer;
        
        private bool _changed;

        /*
        *   Content changed
        */
        internal bool Changed {
            get {
                return _changed;
            }
            set {
                _changed = value;
                _closeButton.image = _changed ? _changedImage : _closeImage;
            }
        }

        private string _caption; 

        /*
        *   Caption of page
        */
        internal string Caption { 
            get {
                return _caption;
            } 
            private set {
                if (_captionLabel != null) {                
                    _caption = value;
                    _captionLabel.label = _caption;
                } else {
                    _caption = "";
                }
            } 
        }

        private string _filePath;

        /*
        *   Content file name
        */
        internal string FilePath {
            get {
                return _filePath;
            }
            set {
                var file = File.new_for_path (value);
                Caption = file.get_basename ();
                _filePath = value;
            }
        }

        /*
        *   Is temp
        */
        internal bool IsTemp;    

        /*
        *   Signal when close click
        */
        internal signal void OnPageClose (SourcePage page);

        /*
        *   Signal when focus in
        */
        internal signal void OnFocusIn (SourcePage page);

        /*
        *   Signal when  focus out
        */
        internal signal void OnFocusOut (SourcePage page);                  

        /*
        *   Create page with source
        */
        private void CreatePage (string data) {
            var langManager = new Gtk.SourceLanguageManager();
            var lang = langManager.get_language ("vala");
            _buffer = new Gtk.SourceBuffer.with_language (lang);
            var styleManager = new Gtk.SourceStyleSchemeManager ();
            styleManager.append_search_path (".");
            var styleScheme = styleManager.get_scheme ("vscode");
            _buffer.set_style_scheme (styleScheme);
            _buffer.set_text (data);            

            var view = new Gtk.SourceView.with_buffer (_buffer);
            view.highlight_current_line = true;
            view.auto_indent = true;
            view.show_line_numbers = true;
            view.left_margin = SourceEditor.LEFT_MARGIN;
            view.pixels_above_lines = SourceEditor.LINE_MARGIN;
            view.tab_width = SourceEditor.DEFAULT_TAB_WIDTH;

            _rootWidget = new Gtk.ScrolledWindow (null, null);
            _rootWidget.add (view);
            
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            _captionLabel = new Gtk.Label (Caption);
            _closeButton = new Gtk.Button ();
            _closeButton.get_style_context ().add_class ("button-icon");
            _closeImage = new Gtk.Image.from_file ("./Data/cross.svg");            
            _changedImage = new Gtk.Image.from_file ("./Data/circle.svg");
            _closeButton.image = _closeImage;            
            box.pack_start (_captionLabel, true, true);
            box.pack_start (_closeButton, false, false);
            _notebook.append_page (_rootWidget, box);
            box.show_all ();            

            _changed = false;

            _closeButton.clicked.connect (() => {
                OnPageClose (this);                
            });

            _closeButton.enter_notify_event.connect ((e) => {
                _closeButton.image = _closeImage; 
                return true;
            });

            _closeButton.leave_notify_event .connect ((e) => {
                if (_changed) _closeButton.image = _changedImage; 
                return true;
            });

            view.focus_in_event.connect ((e) => {
                OnFocusIn (this);
                return false;
            });

            view.focus_out_event.connect ((e) => {
                OnFocusOut (this);
                return false;
            });

            _buffer.changed.connect (() => {                
                Changed = true;
            });
        }

        /*
        *   Remove page
        */
        internal void RemovePage () {
            _notebook.detach_tab (_rootWidget);
        }

        /*
        *   Return file content        
        */
        internal TextContent GetFileContent () {
            if (IsTemp) {
                return new TextContent (_buffer.text);
            }

            return new TextFileContent (_filePath, _buffer.text);
        }

        /*
        *   Constructor
        */
        public SourcePage (string filePath, string data, bool isTemp, Gtk.Notebook notebook) {
            _notebook = notebook;            
            IsTemp = isTemp;            
            CreatePage (data);
            FilePath  = filePath;
        }        
    }
}