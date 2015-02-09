class Planit

  # ------------------------------------------ Refs

  @containerClass:        'planit-container'
  @markerContainerClass:  'planit-markers-container'
  @markerClass:           'planit-marker'
  @markerContentClass:    'planit-marker-content'

  # ------------------------------------------ Default Options

  new: (@options = {}) ->
    # Set Options
    if @options.container
      @options.container = $("##{@options.container}")
    else
      @options.container = $('#planit') 

    # Initialize Container
    @options.container.addClass('planit-container')
    @options.container.append """
      <div class="#{Planit.markerContainerClass}"></div>
        """

    # Refs
    @container = @options.container
    @markersContainer = @container.find(".#{Planit.markerContainerClass}").first()

    # Add Background Image (if necessary)
    if @options.backgroundImage
      @container.append("""<img src="#{@options.backgroundImage}">""")
      @markersContainer.css
        backgroundImage: "url('#{@options.backgroundImage}')"
      $(window).load =>
        @container.css
          height: @container.find('img').first().height()
        @container.find('img').first().remove()

    # Add Markers (if necessary)
    if @options.markers
      $(window).load () =>
        @addMarker(marker) for marker in @options.markers

    # Bind Document Events
    new Planit.Plan.Events
      container: @container
      planit: @

    # Return this Planit object
    @

  # ------------------------------------------ Add A Marker

  addMarker: (options) =>
    options.container = @container
    new Planit.Marker.Creator(options)

  # ------------------------------------------ Retrieve Data

  getMarker: (id) =>
    new Planit.Marker(@container, id)

  getAllMarkers: () =>
    plan = new Planit.Plan(@container)
    plan.getAllMarkers()

  # ------------------------------------------ Event Callbacks

  dragEnd: (event, marker) =>
    if @options.dragEnd
      @options.dragEnd(event, marker)

  # ------------------------------------------ Class Methods

  @randomString: (length = 16) ->
    str = Math.random().toString(36).slice(2) 
    str = str + Math.random().toString(36).slice(2)
    str.substring(0, length - 1)

# set this class to a global `planit` variable
window.planit = new Planit
