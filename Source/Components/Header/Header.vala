namespace  Aphelion {
    /*
    *   Main window component
    */
    public class Header : Component {
        /*
        *   Header bar widget
        */
        private Gtk.HeaderBar _header;

        /*
        *   Create component items
        */
        public override void Init () {            
            _header = new Gtk.HeaderBar ();
            _header.show_close_button = true;            
        }

        /*
        *   Install component
        */
        public override async void Install () {
            MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (MainWindow), new SetHeaderWidgetMessage (_header));
        }        
    }
}