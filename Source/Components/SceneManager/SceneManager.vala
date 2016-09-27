namespace  Aphelion {
    /*
    *   Standard scene manager
    */
    public class SceneManager : Component { 
        /*
        *   Create component items
        */
        public void Init () {
            
        }

        /*
        *   Install component
        */
        public void Install () {
            var manager = ComponentManager.GetInstance ();
            manager.Install (typeof (MainWindow));
            manager.Install (typeof (Header));
            manager.Install (typeof (Workspace));
            manager.Install (typeof (SourceEditor));
            manager.Install (typeof (CommandManager));
            manager.Install (typeof (FileDialog));
        }
    }
}