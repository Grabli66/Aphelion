namespace  Aphelion {
    /*
    *   Save as command 
    */
    public class SaveAsCommand : Object, ICommand {
        /*
        *   Run command
        */        
        public void Run () {
            stderr.printf ("SAVE AS"); 
        }
    }   
}