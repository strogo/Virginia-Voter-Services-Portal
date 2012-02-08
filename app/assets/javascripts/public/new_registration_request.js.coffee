# Eligibility section
class EligibilitySection extends Forms.Section
  constructor: (navigationListener) ->
    oname   = 'registration_request'
    oid     = "##{oname}"
    section = $('#eligibility')

    # Fields
    @citizen            = $("#{oid}_citizen")
    @age                = $("#{oid}_old_enough")
    @residence          = $("input[name='#{oname}[residence]']")
    @residenceInside    = $("#{oid}_residence_in")
    @livingOutside      = $("input[name='#{oname}[outside_type]']")
    @convicted          = $("input[name='#{oname}[convicted]']")
    @convictedRestored  = $("#{oid}_convicted_restored")
    @convictedFalse     = $("#{oid}_convicted_false")
    @mental             = $("input[name='#{oname}[mental]']")
    @mentalRestored     = $("#{oid}_mental_restored")
    @mentalFalse        = $("#{oid}_mental_false")

    # Configure feedback popover on Next button
    btnNext = $('button.next', section)
    popover = new Feedback.Popover(btnNext)
    popover.addItem(new Feedback.Checked(@citizen, 'Citizenship criteria'))
    popover.addItem(new Feedback.Checked(@age, 'Age criteria'))
    popover.addItem(new Feedback.Checked(@residence, 'Residence selection'))
    popover.addItem(new Feedback.Checked(@livingOutside, 'Reason for living outside', skipIf: => @residenceInside.is(":checked") or !@residence.is(":checked")))
    popover.addItem(new Feedback.Checked(@convicted, 'Convictions status'))
    popover.addItem(new Feedback.Checked(@mental, 'Mental status'))
    unrestoredRights = "You can't vote until your rights are restored"
    popover.addItem(new Feedback.Checked(@convictedRestored, unrestoredRights, skipIf: => @convictedFalse.is(":checked") or !@convicted.is(":checked") ))
    popover.addItem(new Feedback.Checked(@mentalRestored, unrestoredRights, skipIf: => @mentalFalse.is(":checked") or !@mental.is(":checked") ))

    new Forms.BlockToggleField(oid + '_residence_outside', 'div.outside')
    new Forms.BlockToggleField(oid + '_outside_type_active_duty', 'div.add')
    new Forms.BlockToggleField(oid + '_outside_type_spouse_active_duty', 'div.sadd')
    new Forms.BlockToggleField(oid + '_convicted_true', '.convicted-details')
    new Forms.BlockToggleField(oid + '_convicted_restored', '.convicted-details .restored')
    new Forms.BlockToggleField(oid + '_mental_true', '.mental-details')
    new Forms.BlockToggleField(oid + '_mental_restored', '.mental-details .restored')

    super '#eligibility', navigationListener

  isComplete: =>
    ch = (id) -> $(id).is(":checked")

    ch(@citizen) and ch(@age) and
      (ch(@residenceInside) or ch(@livingOutside)) and
      (ch(@convictedFalse) or ch(@convictedRestored)) and
      (ch(@mentalFalse) or ch(@mentalRestored))



# Identify Yourself section
class IdentitySection extends Forms.Section
  constructor: (navigationListener) ->
    oname   = 'registration_request'
    oid     = "##{oname}"
    section = $('#identity')

    # Fields
    @lastName = $("#{oid}_last_name")
    @gender   = $("#{oid}_gender")
    @ssn      = $("#{oid}_ssn")
    @dln      = $("#{oid}_dln")
    @noSsn    = $("#{oid}_no_ssn")

    # Configure feedback popover on Next button
    popover = new Feedback.Popover($('button.next', section))
    popover.addItem(new Feedback.Filled(@lastName, 'Last name'))
    popover.addItem(new Feedback.Filled(@gender, 'Gender'))
    popover.addItem(new Feedback.Filled(@ssn, 'Social Security #', skipIf: => @noSsn.is(":checked")))
    popover.addItem(new Feedback.Filled(@dln, 'Drivers license or State ID', skipIf: => !@noSsn.is(":checked")))

    new Forms.BlockToggleField("#{oid}_no_ssn", '.dln')

    super '#identity', navigationListener

  validSsn: ->
    @ssn.val().match(new RegExp(@ssn.attr('data-format'), 'gi'))

  validDln: ->
    @dln.val().match(new RegExp(@dln.attr('data-format'), 'gi'))

  isComplete: =>
    checked = (id) -> $(id).is(":checked")
    filled  = (id) -> $(id).val().match(/^[^\s]+$/)

    filled(@lastName) and filled(@gender) and
      (if checked(@noSsn) then @validDln() else @validSsn())



class ContactInfoSection extends Forms.Section
  constructor: (navigationListener) ->
    new Forms.BlockToggleField('#registered_in_another_state', '#another_state')
    super '#contact_info', navigationListener


class Form extends Forms.MultiSectionForm
  constructor: ->
    super [
#      new EligibilitySection(this),
      new IdentitySection(this),
#      new ContactInfoSection(this),
    ], new Forms.StepIndicator(".steps")


$ ->
  return unless $('form#new_registration_request').length > 0
  new Form

