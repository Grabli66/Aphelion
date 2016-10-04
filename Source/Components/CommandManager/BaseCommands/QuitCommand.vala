namespace  Aphelion {
    /*
    *   Quit command 
    */
    public class QuitCommand : Object, ICommand {
        /*
        *   Run command
        */        
        public async void Run () {
            Gtk.main_quit (); 
        }
    }   
}