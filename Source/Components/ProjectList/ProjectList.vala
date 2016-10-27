namespace  Aphelion {
    /*
    *   List view with projects
    */
    public class ProjectList : Component {
        /*
        *   Root widget
        */
        private Gtk.Box _rootBox;

        /*
        *   Root widget
        */
        private Gtk.TreeView _projectList;

        /*
        *   Create component items
        */
        public override void Init () {
            _rootBox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            var headerBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);                         
            headerBox.get_style_context ().add_class ("panel-header"); 
            var header = new Gtk.Label ("Projects");

            header.halign = Gtk.Align.START;
            header.margin = 5;   
            headerBox.pack_start (header, true, true, 5);                     
            _rootBox.pack_start (headerBox, false, false);

            _projectList = new Gtk.TreeView ();
            _projectList.set_size_request (270, -1);
            _projectList.get_style_context ().add_class ("project-list");             
            var store = new Gtk.TreeStore (2, typeof (string), typeof (string));
            _projectList.set_model (store);

            _projectList.insert_column_with_attributes (-1, "Product", new Gtk.CellRendererText (), "text", 0, null);
            //_projectList.insert_column_with_attributes (-1, "Price", new Gtk.CellRendererText (), "text", 1, null);

            Gtk.TreeIter root;
            Gtk.TreeIter category_iter;
            Gtk.TreeIter product_iter;

            store.append (out root, null);
            store.set (root, 0, "All Products", -1);

            store.append (out category_iter, root);
            store.set (category_iter, 0, "Books", -1);

            store.append (out product_iter, category_iter);
            store.set (product_iter, 0, "Moby Dick", 1, "$10.36", -1);
            store.append (out product_iter, category_iter);
            store.set (product_iter, 0, "Heart of Darkness", 1, "$4.99", -1);
            store.append (out product_iter, category_iter);
            store.set (product_iter, 0, "Ulysses", 1, "$26.09", -1);
            store.append (out product_iter, category_iter);
            store.set (product_iter, 0, "Effective Vala", 1, "$38.99", -1);

            store.append (out category_iter, root);
            store.set (category_iter, 0, "Films", -1);

            store.append (out product_iter, category_iter);
            store.set (product_iter, 0, "Amores Perros", 1, "$7.99", -1);
            store.append (out product_iter, category_iter);
            store.set (product_iter, 0, "Twin Peaks", 1, "$14.99", -1);
            store.append (out product_iter, category_iter);
            store.set (product_iter, 0, "Vertigo", 1, "$20.49", -1);

            _projectList.headers_visible = false;
            _projectList.expand_all ();
            _rootBox.pack_start (_projectList, true, true);
        }

        /*
        *   Install component
        */
        public override async void Install () {
            yield MessageDispatcher.Send (this.get_type (), typeof (Workspace), new PlaceWidgetMessage (_rootBox, WorkspacePlace.LEFT));            
        }  
    }
}