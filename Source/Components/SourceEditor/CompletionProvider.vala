namespace  Aphelion {
    /*
    *   Completion provider
    */
    public class CompletionProvider : Object, Gtk.SourceCompletionProvider {
        private const int INTERACTIVE_DELAY = 1000;

        /*
        *   Label for proposal
        */        
        private Gtk.Label _infoLabel;

        /*
        *   SourcePage parent
        */
        private SourcePage _parent;

        /*
        *   Populate context internal
        */
        private async void PopulateInternal (Gtk.SourceCompletionContext context) {            
            // Get line and column
			var iter = context.iter;
            var line = iter.get_line();
            var column = iter.get_line_offset();			

            var text = _parent.Buffer.text;
            yield MessageDispatcher.Send (this.get_type (), typeof (Completion), new RegisterSourceMessage (text));
            var comp = yield MessageDispatcher.Send (this.get_type (), typeof (Completion), 
                             new GetCompletionMessage ("", line, column));
                    
            if (comp == null) return;
            
            var completion = (ReturnCompletionMessage) comp;
            var comps = completion.Completions;

            var list = new List<Gtk.SourceCompletionProposal>();
            foreach (var item in comps) {
                list.append (new CompletionProposal (item));
            }
                        
            context.add_proposals (this, list, true);
        }

        /*
        *   Constructor
        */        
        public CompletionProvider (SourcePage page) {
            _parent = page;
        }

        /*
        *   Return completion name
        */
        public string get_name() {
			return "Vala";
		}

        /*
        *   Delay before completion
        */
        public int get_interactive_delay () {            
            return INTERACTIVE_DELAY;
        }

        /*
        *   Return widget for proposal
        */
        public unowned Gtk.Widget? get_info_widget (Gtk.SourceCompletionProposal proposal) {
            _infoLabel = new Gtk.Label (proposal.get_text ());
            _infoLabel.show_all ();
            return _infoLabel;
        }        

        /*
        *   Populate proposals
        */
        public void populate (Gtk.SourceCompletionContext context) {
            PopulateInternal.begin (context, (o, e)=> {
                PopulateInternal.end (e);
            });            
        }
    }
}