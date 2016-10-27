namespace  Aphelion {
    /*
    *   Standard scene manager
    */
    public class Workspace : Component { 
        /*
        *   Root paned widget
        */
        private Gtk.Paned _rootPaned;                

        /*
        *   Center paned widget
        */
        private Gtk.Paned _centerPaned;        

        /*
        *   Place widget to some place 
        */
        private Message? PlaceWidget (Type sender, Message data) {
            var messa = (PlaceWidgetMessage) data;

            switch (messa.Place) {
                case WorkspacePlace.CENTER:
                    _rootPaned.add2 (messa.Widget);
                    break;
                case WorkspacePlace.LEFT:
                    _rootPaned.add1 (messa.Widget);
                    break;
            default:
                break;
            }
            messa.Widget.show_all ();        
            return null;
        }

        /*
        *   Create component items
        */
        public override void Init () {
            _rootPaned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

            // Register messages
            MessageDispatcher.Register (this, typeof (PlaceWidgetMessage), PlaceWidget);
        }

        /*
        *   Install component
        */
        public override async void Install () {
            MessageDispatcher.Send (this.get_type (), typeof (MainWindow), new SetRootWidgetMessage (_rootPaned));          
        }         
    }
}