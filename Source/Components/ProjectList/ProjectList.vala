namespace  Aphelion {
    /*
    *   List view with projects
    */
    public class ProjectList : Component {
        /*
        *   Root widget
        */
        private Gtk.Widget _projectList;

        /*
        *   Create component items
        */
        public override void Init () {
        }

        /*
        *   Install component
        */
        public override async void Install () {
            MessageDispatcher.Send (this.get_type (), typeof (Workspace), new PlaceWidgetMessage (_projectList, WorkspacePlace.LEFT));
        }  
    }
}