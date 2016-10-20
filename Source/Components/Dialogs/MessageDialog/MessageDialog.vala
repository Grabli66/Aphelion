namespace  Aphelion {
    /*
    *   Dialog with message and confirm/cancel buttons
    */
    public class MessageDialog : Gtk.Dialog, IDialog {
        /*
        *   Result of dialog
        */
        private MessageDialogResult _result;

        /*
        *   Constructor
        */
        public MessageDialog (Gtk.Window mainWindow) {
            set_transient_for (mainWindow);
            this.title = "_Message";
            this.border_width = 5;
            set_default_size (450, 300);  

            // Layout widgets
            Gtk.Box content = get_content_area () as Gtk.Box;

            var messageLabel = new Gtk.Label ("_Message");
            messageLabel.halign = Gtk.Align.CENTER;
		    Gtk.Box hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
		    hbox.pack_start (messageLabel, true, true, 0);
            content.pack_start (hbox, true, true, 0);

            add_button ("_OK", Gtk.ResponseType.APPLY);
            add_button ("_Cancel", Gtk.ResponseType.CLOSE);

            this.response.connect (OnResponse);   
            this.modal = true;
            show_all ();                   
	    }

        /*
        *   On dialog response
        */
        private void OnResponse (Gtk.Dialog source, int responseId) {
            switch (responseId) {                                                        
                case Gtk.ResponseType.APPLY:
                    _result = MessageDialogResult.OK;
                    destroy ();                    
                    break;
                case Gtk.ResponseType.CLOSE:
                    _result = MessageDialogResult.CANCEL;
                    destroy ();
                    break;
                default:
                    destroy ();
                    break;                   
		    }
	    }


        /*
        *   Show dialog and return message
        */
        public Message? ShowWithResult () {            
            this.run ();                        
            return new ReturnMessageDialogResultMessage (_result);
        }
    }
}