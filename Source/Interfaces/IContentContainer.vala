namespace Aphelion {
    /*
    *   Interface for component that has saveable content
    */
    public interface IContentContainer : Object {
        /*
        *   Return content if exists
        */
        public abstract TextFileData? GetContentData ();       
    }
}