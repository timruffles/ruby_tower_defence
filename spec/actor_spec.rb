require_relative 'spec_helper'
describe Actor do
  let (:actor) { Actor.new }
  it "passes self to all abilities" do
    ability = mock('Ability')
    ability.expects(:actor=).with(actor)
    actor.abilities = [ability]
  end
  it "has access to world" do
    actor.world.should be_a(World)
  end
  it "knows when it's dead" do
    actor.hps = 0
    actor.should be_dead
  end
  ['hps'].each do |attribute|
    it "publishes events when #{attribute} changes" do
      actor.expects(:pub)
      actor.send "#{attribute}=", 1
    end
  end
end