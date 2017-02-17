define([], function(){
    var _locked = false;
    return {
        lock:function(){
            _locked = true;
        },
        unlock:function(){
            _locked = false;
        },
        isLocked:function(){
            return _locked;
        }
    };
});