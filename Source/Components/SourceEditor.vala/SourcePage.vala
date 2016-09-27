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

        /*
        *   Content changed
        */
        private bool _changed;

        /*
        *   Caption of page
        */
        internal string Caption { get; private set; }

        /*
        *   Content file name
        */
        internal string FilePath { get; private set; }

        /*
        *   Is temp
        */
        internal bool IsTemp { get; private set; }

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
        *   Remove page
        */
        internal void RemovePage () {
            _notebook.detach_tab (_rootWidget);
        }        

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
            var label = new Gtk.Label (Caption);
            _closeButton = new Gtk.Button ();
            _closeButton.get_style_context ().add_class ("button-icon");
            _closeImage = new Gtk.Image.from_file ("./Data/cross.svg");            
            _changedImage = new Gtk.Image.from_file ("./Data/circle.svg");
            _closeButton.image = _closeImage;            
            box.pack_start (label, true, true);
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
                SetChanged (true);
            });
        }

        /*
        *   Return file content        
        */
        internal TextContent GetFileContent () {
            if (IsTemp) {
                return new TextContent (_buffer.text);
            }

            return new TextFileContent (FilePath, _buffer.text);
        }

        /*
        *   Set content changed flag
        */
        internal void SetChanged (bool ch) {
            _changed = ch;
            _closeButton.image = _changed ? _changedImage : _closeImage;            
        }

        /*
        *   Constructor
        */
        public SourcePage (string filePath, string data, bool isTemp, Gtk.Notebook notebook) {
            _notebook = notebook;
            FilePath = filePath;
            IsTemp = isTemp;
            var file = File.new_for_path (filePath);
            Caption = file.get_basename ();
            CreatePage (data);
        }        
    }
}