using Gtk;

namespace Aphelion {
    public int main (string[] args) {
        Gtk.init (ref args);
        
        var mainWindow = new MainWindow ();
        mainWindow.show_all ();

        Gtk.main ();
        return 0;
    }
}