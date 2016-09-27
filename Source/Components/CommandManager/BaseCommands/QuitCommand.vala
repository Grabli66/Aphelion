namespace  Aphelion {
    /*
    *   Quit command 
    */
    public class QuitCommand : Object, ICommand {
        /*
        *   Run command
        */        
        public void Run () {
            Gtk.main_quit (); 
        }
    }   
}