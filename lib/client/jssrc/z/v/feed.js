var Feed = BB.View.extend({
  maxMessages: 5,
  initialize: function() {
    this.messagesDisplayed = [];
    dojo.sub('tick',this,'render');
  },
  render: function(events) {
    if(!this.loaded) {
      this.loaded = true;
      this.$().removeClass('loading');
    }
    _.forEach(events,function(event) {
      var message = event.description;
      if(!message) return;
      var element = $('<li>' + message + '</li>');
      this.$().prepend(element);
      element.slideDown();
      this.messagesDisplayed.unshift(element);
      if (this.messagesDisplayed.length > this.maxMessages) this.messagesDisplayed.pop().remove();
    },this);
  }
});
