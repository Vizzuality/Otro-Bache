;(function($){
$.fn.objectSize = function(){

    function calculateSize(domNode){
        var divSizer = $(document.createElement("div"))
        .attr("id", "sizer")
        .css({           
            position: 'absolute',
            left: '-10000px' 
        }).appendTo('body'),
        size = {width: 0, height: 0};
    
        divSizer.append(domNode);
        size.width = parseInt(domNode.outerWidth());
        size.height = parseInt(domNode.outerHeight());
        divSizer.remove();
        delete divSizer;
        return size;
    }

    return calculateSize($(this[0]));
};
})(jQuery);