namespace  Aphelion {
    /*
    *   Request to get file content       
    */
    public class GetFileContentMessage : Message {
        /*
        *   Get only changed content
        */
        public bool OnlyChanged { get; private set; }

        public GetFileContentMessage (bool onlyChanged) {
            OnlyChanged = onlyChanged;
        }
    }
}