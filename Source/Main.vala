using Gtk;

namespace Aphelion {
    public int main (string[] args) {
        Gtk.init (ref args);        

        var manager = ComponentManager.GetInstance ();
        manager.Load ();

        Gtk.main ();
        return 0;
    }
}