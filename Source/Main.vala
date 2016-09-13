using Gtk;

namespace Aphelion {
    public int main (string[] args) {
        Gtk.init (ref args);
        
        var compManager = ComponentManager.GetInstance ();
        compManager.LoadComponents ();                

        Gtk.main ();
        return 0;
    }
}