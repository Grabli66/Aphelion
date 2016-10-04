namespace  Aphelion {
    /*
    *   Close command 
    */
    public class CloseCommand : Object, ICommand {                
        /*
        *   Run command
        */        
        public async void Run () {
            MessageDispatcher.GetInstance ().SendBroadcast (this.get_type (), new CloseMessage ()); 
        }
    }   
}