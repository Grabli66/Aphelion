namespace  Aphelion {
    /*
    *   Standard scene manager
    */
    public class Workspace : Component { 
        /*
        *   Root widget
        */
        private Gtk.Box _rootBox;

        /*
        *   Place widget to some place 
        */
        private Message? PlaceWidget (Type sender, Message data) {
            var message = (PlaceWidgetMessage) data;
            _rootBox.pack_start (message.Widget);
            return null;
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _rootBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages
            dispatcher.Register (this, typeof (PlaceWidgetMessage), PlaceWidget);
        }

        /*
        *   Install component
        */
        public override async void Install () {
            MessageDispatcher.GetInstance ().Send (this.get_type (), typeof (MainWindow), new SetRootWidgetMessage (_rootBox));          
        }         
    }
}