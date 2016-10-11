namespace  Aphelion {
    /*
    *   Completion provider
    */
    public class CompletionProposal : Object, Gtk.SourceCompletionProposal {
        /*
        *   Proposal text
        */      
        private string _text;

        /*
        *   Constructor
        */
        public CompletionProposal (string text) {
            _text = text;
        }
          
        /*
        *   Return icon
        */
        public unowned GLib.Icon? get_gicon() {
			return null;
		}
        
		public unowned string? get_icon_name() { return null; }
		public string? get_info() { return _text; }
		public string get_label() { return _text; }
		public string get_markup() { return _text; }
		public string get_text() { return _text; }			
    }
}