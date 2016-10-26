namespace  Aphelion {
    /*
    *   Standard scene manager
    */
    public class Workspace : Component { 
        /*
        *   Root widget
        */
        private Gtk.Box _rootBox;

        private Gtk.Box _topBox;

        private Gtk.Box _centerLineBox;

        private Gtk.Box _leftBox;

        private Gtk.Box _centerBox;

        private Gtk.Box _rightBox;

        private Gtk.Box _bottomBox;

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

            // Register messages
            MessageDispatcher.Register (this, typeof (PlaceWidgetMessage), PlaceWidget);
        }

        /*
        *   Install component
        */
        public override async void Install () {
            MessageDispatcher.Send (this.get_type (), typeof (MainWindow), new SetRootWidgetMessage (_rootBox));          
        }         
    }
}