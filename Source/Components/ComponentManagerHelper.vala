namespace Aphelion {
    /*
    *   Helper methods for component manager
    */
    [Compact]
    internal class ComponentManagerHelper {
        /*
        *   Return main window widget
        */
        public static Gtk.Window GetMainWindowWidget () {
            var compManager = ComponentManager.GetInstance ();
            var mainWindow = compManager.Get (MainWindow.DEFAULT_ID) as MainWindow;
            return mainWindow.GetRootWidget () as Gtk.Window;
        }
    }
}