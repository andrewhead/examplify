{ ExampleModelProperty } = require "../../lib/model/example-model"
{ ExampleModelState } = require "../../lib/model/example-model"
{ ControlStructureExtension } = require "../../lib/extender/control-structure-extender"
{ IfControlStructure, ForControlStructure, WhileControlStructure, DoWhileControlStructure, TryCatchControlStructure } = require "../../lib/analysis/parse-tree"


# Interface for an agent that listens to changes in the model and acts on the
# user's behalf.  For example, there might be an agent that automatically
# accepts all code recommendations, or chooses random errors and resolutions.
# This class is not meant to be used directly.  You should extend it, defining
# what the agent should do when:
# * chooseError: the user is supposed to choose an error to resolve
#   * Arguments: list of errors to choose from
#   * Returns: one chosen error
# * chooseResolution: the user is supposed to choose a resolution to an error
#   * Arguments: list of resolutions to choose from
#   * Returns: one chosen resolution
# * acceptExtension: the user is supposed to accept or reject a code extension
#   * Arguments: an extension to be accepted or rejected
#   * Returns: true if accepted, false if rejected
module.exports.Agent = class Agent

  constructor: (model) ->
    @model = model
    @model.addObserver @

  onEnterErrorChoiceState: ->
    errorChoice = @chooseError @model.getErrors()
    @model.setErrorChoice errorChoice

  onEnterResolutionState: ->
    resolutionChoice = @chooseResolution @model.getSuggestions()
    @model.setResolutionChoice resolutionChoice

  onEnterExtensionState: ->
    extensionDecision = @acceptExtension @model.getProposedExtension()
    @model.setExtensionDecision extensionDecision

  onPropertyChanged: (object, propertyName, oldValue, newValue) ->
    if propertyName is ExampleModelProperty.STATE
      switch newValue
        when ExampleModelState.ERROR_CHOICE then @onEnterErrorChoiceState()
        when ExampleModelState.RESOLUTION then @onEnterResolutionState()
        when ExampleModelState.EXTENSION then @onEnterExtensionState()


# Many agents may want to just accept all try-catch blocks (which may be
# needed to compile the program) and for-loops (which can define variables).
# This method can be used as those agents' `acceptExtension` method.
module.exports.acceptOnlyForLoopsAndTryBlocks =\
  acceptOnlyForLoopsAndTryBlocks = (extension) ->
    return false if not (extension instanceof ControlStructureExtension)
    controlStructure = extension.getControlStructure()
    accept = ((controlStructure instanceof ForControlStructure) or
      (controlStructure instanceof TryCatchControlStructure))
    accept
