require_relative 'spec_helper'
describe Actor do
  let (:actor) { Actor.new }
  it "passes self to all abilities" do
    ability = mock('Ability')
    ability.expects(:actor=).with(actor)
    actor.abilities = [ability]
  end
end