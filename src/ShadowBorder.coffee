
{Component, Style} = require "modx"
{View, ImageView} = require "modx/views"

OneOf = require "OneOf"

Alignment = OneOf [ "top", "bottom", "left", "right" ]

type = Component "ShadowBorder"

type.defineProps
  style: Style
  align: Alignment.isRequired
  length: Number.isRequired # TODO: Support flex
  borderColor: String
  borderWidth: Number.isRequired
  borderOpacity: Number
  shadowImage: Object.isRequired # TODO: Support dynamic shadows
  shadowHeight: Number.isRequired
  shadowColor: String
  shadowOpacity: Number

type.render ->
  return View
    pointerEvents: "none"
    style: @props.style
    children: [
      @_renderBorder()
      @_renderShadow()
    ]

type.defineMethods

  _renderBorder: ->
    return View
      style: [
        @styles.border()
        @_getBorderSize()
        @_getPosition 0 - @props.borderWidth
      ]

  _renderShadow: ->
    return ImageView
      source: @props.shadowImage
      tintColor: @props.shadowColor
      resizeMode: "stretch"
      style: [
        @styles.shadow()
        @_getPosition 0 - @props.borderWidth - @props.shadowHeight
      ]

  _isHorizontal: ->
    switch @props.align
      when "top" then yes
      when "bottom" then yes
      when "left" then no
      when "right" then no

  _getBorderSize: ->
    if @_isHorizontal()
      width: @props.length
      height: @props.borderWidth
    else
      width: @props.borderWidth
      height: @props.length

  _getShadowRotation: ->
    switch @props.align
      when "top" then "180deg"
      when "bottom" then undefined # AKA 0deg
      when "left" then "270deg"
      when "right" then "90deg"

  _getPosition: (offset) ->
    switch @props.align
      when "top" then {top: offset}
      when "bottom" then {bottom: offset}
      when "left" then {left: offset}
      when "right" then {right: offset}

type.defineStyles

  border:
    position: "absolute"
    backgroundColor: -> @props.borderColor
    opacity: -> @props.borderOpacity ? 1

  shadow:
    position: "absolute"
    width: -> @props.length
    height: -> @props.shadowHeight
    backgroundColor: colors.clear
    opacity: -> @props.shadowOpacity ? 1
    rotate: -> @_getShadowRotation()

module.exports = type.build()
