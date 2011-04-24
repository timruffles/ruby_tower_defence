var LiveFeed = BB.View.extend({
  maxMessages: 5,
  initialize: function() {
    this.messagesDisplayed = [];
    dojo.sub('event',this,'render');
  },
  render: function(event) {
    if(!this.loaded) {
      this.loaded = true;
      this.$.removeClass('loading');
    }
    var message = event.description;
    var element = doc.createElement('li');
    element.innerHTML = message;
    this.$.prepend(element);
    element.slideDown();
    this.messagesDisplayed.unshift(element);
    if (this.messagesDisplayed.length > this.maxMessages) this.messagesDisplayed.pop().remove();
  }
});