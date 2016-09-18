namespace Aphelion {
    /*
    *   Manage settings: load, save, etc
    */
    public class SettingsManager : Component {
        /*
        *   Load settings file
        */
        public override void OnInit () {

        }

        /*
        *   Apply settings
        */
        public override void OnPostInit () {
            var compManager = ComponentManager.GetInstance ();
            var scm = compManager.Get (ShortcutManager.DEFAULT_ID) as ShortcutManager;

            // TODO: Load save shortcuts from settings
            scm.Add (new Shortcut.FromString ("Ctrl+O", new OpenFileAction()));
            scm.Add (new Shortcut.FromString ("Ctrl+S", new SaveFileAction()));
            //scm.Add (new Shortcut.FromString ("Ctrl+Shift+S"));
        }
    }
}