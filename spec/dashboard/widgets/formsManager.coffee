describe 'Dashboard.Widgets.FormsManager', ->
  describe '#exitEditMode', ->
    it 'hides the forms of all widgets on the screen', ->
      setFixtures """
        <div data-name='widget-form' id='form1'></div>
        <div data-name='widget-form' id='form2'></div>
      """
      manager = new Dashboard.Widgets.FormsManager()

      manager.exitEditMode()
      expect($('#form1').attr('style')).toEqual('display: none;')
      expect($('#form2').attr('style')).toEqual('display: none;')

    it 'hides all the closing buttons', ->
      setFixtures """
        <div data-name='widget-close' id='close1'></div>
        <div data-name='widget-close' id='close2'></div>
      """
      manager = new Dashboard.Widgets.FormsManager()

      manager.exitEditMode()
      expect($('#close1').attr('style')).toEqual('display: none;')
      expect($('#close2').attr('style')).toEqual('display: none;')

    it 'animates hide with the time it is initialized with', ->
      manager = new Dashboard.Widgets.FormsManager(300)
      spy = spyOn($.prototype, 'hide')

      manager.exitEditMode()
      expect(spy).toHaveBeenCalledWith(300)

  describe '#enterEditMode', ->
    it 'shows the forms of all widgets on the screen', ->
      setFixtures """
        <div data-name='widget-form' id='form1'></div>
        <div data-name='widget-form' id='form2'></div>
      """
      manager = new Dashboard.Widgets.FormsManager()

      manager.exitEditMode()
      expect($('#form1').attr('style')).toEqual('display: none;')
      expect($('#form2').attr('style')).toEqual('display: none;')

      manager.enterEditMode()
      expect($('#form1').attr('style')).not.toEqual('display: none;')
      expect($('#form2').attr('style')).not.toEqual('display: none;')

    it 'shows all the closing buttons', ->
      setFixtures """
        <div data-name='widget-close' id='close1'></div>
        <div data-name='widget-close' id='close2'></div>
      """
      manager = new Dashboard.Widgets.FormsManager()

      manager.exitEditMode()
      expect($('#close1').attr('style')).toEqual('display: none;')
      expect($('#close2').attr('style')).toEqual('display: none;')

      manager.enterEditMode()
      expect($('#close1').attr('style')).not.toEqual('display: none;')
      expect($('#close2').attr('style')).not.toEqual('display: none;')

    it 'animates show with the time it is initialized with', ->
      manager = new Dashboard.Widgets.FormsManager(300)
      spy = spyOn($.prototype, 'show')

      manager.enterEditMode()
      expect(spy).toHaveBeenCalledWith(300)
