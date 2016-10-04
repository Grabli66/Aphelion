namespace  Aphelion {
    /*
    *   Command for something new 
    */
    public class NewCommand : Object, ICommand {                
        /*
        *   Run command
        */        
        public async void Run () {
             MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new NewMessage ()); 
        }
    }   
}