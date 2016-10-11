namespace  Aphelion {
    /*
    *   Source completion component
    */
    public class Completion : Component {
        /*
        *   Minimum word length for completion
        *   TODO: move to settings
        */
        private const int MIN_WORD_LENGTH = 3;

        /*
        *   Register text buffers
        */
        private Gee.HashMap<string, string> _sources = new Gee.HashMap<string, string> ();
        
        /*
        *   For test
        */
        private string _source;

        /*
        *   For test
        */        
        private Gee.HashSet<string> _words = new Gee.HashSet<string> ();

        /*
        *   For test
        */
        private void StripWords (string data) {
            _words.clear ();
            var regx = new Regex ("[^\\w]");
            var clearData = regx.replace (data, data.length, 0, " ");            
            var words = Regex.split_simple ("\\s+", clearData);                        
            for (int i = 0; i < words.length; i++) {
                var word = words[i];                
                if (word == "") continue;
                _words.add (word);
            }
        }

        /*
        *   Get word from source by line and column
        */
        private string GetWord (string name, int line, int column) {
            var lines = Regex.split_simple ("\n", _source);            
            if (line > lines.length - 1) return "";            
            var lineItem = lines[line];
            if (lineItem.length < 1) return "";            
            if (column > lineItem.length) return "";
            
            int start = 0;
            for (int i = column; i > 0; i--) {
                if (lineItem[i] == ' ') {
                    start = i;
                    break;
                } 
            }            

            //  Remove symbols
            var regx = new Regex ("[^\\w]");            
            var word = lineItem.slice (start, column);  
            word = regx.replace (word, word.length, 0, "");          
            return word;
        }

        /*
        *   Process RegisterSourceMessage
        */
        private Message? RegisterSource (Type sender, Message data) {
            var messa = (RegisterSourceMessage) data;
            _source = messa.Data;
            StripWords (messa.Data);
            return null;
        }        

        /*
        *   Process GetCompletionMessage
        */
        private Message? GetCompletion (Type sender, Message data) {
            var messa = (GetCompletionMessage) data;
            var name = messa.Name;
            var line = messa.Line;
            var col = messa.Column;

            // get word for line and col
            var word = GetWord (name, line, col);
            if (word == "") return null;
            if (word.length < MIN_WORD_LENGTH) return null;
            var res = new string[0];

            foreach (var item in _words) {
                if (item.contains (word) && item != word) res += item;                
            }

            return new ReturnCompletionMessage (res);
        }

        /*
        *   Create component items
        */
        public override void Init () {
            var dispatcher = MessageDispatcher.GetInstance ();
            // Register messages            
            dispatcher.Register (this, typeof (RegisterSourceMessage), RegisterSource);            
            dispatcher.Register (this, typeof (GetCompletionMessage), GetCompletion);
        }
    }
}