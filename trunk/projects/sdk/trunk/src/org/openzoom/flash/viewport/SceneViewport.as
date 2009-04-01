﻿////////////////////////////////////////////////////////////////////////////////////  OpenZoom////  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>////  OpenZoom is free software: you can redistribute it and/or modify//  it under the terms of the GNU General Public License as published by//  the Free Software Foundation, either version 3 of the License, or//  (at your option) any later version.////  OpenZoom is distributed in the hope that it will be useful,//  but WITHOUT ANY WARRANTY; without even the implied warranty of//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the//  GNU General Public License for more details.////  You should have received a copy of the GNU General Public License//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.//////////////////////////////////////////////////////////////////////////////////package org.openzoom.flash.viewport{import flash.events.Event;import flash.events.EventDispatcher;import flash.geom.Point;import flash.geom.Rectangle;import org.openzoom.flash.events.ViewportEvent;import org.openzoom.flash.scene.IReadonlyMultiScaleScene;//------------------------------------------------------------------------------////  Events////------------------------------------------------------------------------------/** * @inheritDoc */[Event(name="resize", type="org.openzoom.events.ViewportEvent")]/** * @inheritDoc */[Event(name="transformStart", type="org.openzoom.events.ViewportEvent")]/** * @inheritDoc */[Event(name="transform", type="org.openzoom.events.ViewportEvent")]/** * @inheritDoc */[Event(name="transformEnd", type="org.openzoom.events.ViewportEvent")]/** * IViewport implementation that is based on a normalized [0, 1] coordinate system. */public class SceneViewport extends EventDispatcher                           implements ISceneViewport{    //--------------------------------------------------------------------------    //    //  Constructor    //    //--------------------------------------------------------------------------    /**     * Constructor.     */      public function SceneViewport(viewport:INormalizedViewport)    {    	this.viewport = viewport    }        private var viewport:INormalizedViewport    //--------------------------------------------------------------------------    //    //  Properties    //    //--------------------------------------------------------------------------    //----------------------------------    //  zoom    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get zoom():Number    {        return viewport.zoom    }    public function set zoom(value:Number):void    {    	viewport.zoom = value    }    //----------------------------------    //  scale    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get scale():Number    {        return viewport.scale    }    public function set scale(value:Number):void    {    	viewport.scale = value    }//    //----------------------------------//    //  constraint//    //----------------------------------////    private var _constraint:IViewportConstraint = NULL_CONSTRAINT////    public function get constraint():IViewportConstraint//    {//        return _constraint//    }////    public function set constraint(value:IViewportConstraint):void//    {//        if (value)//           _constraint = value//        else//           _constraint = NULL_CONSTRAINT//    }    //----------------------------------    //  transformer    //----------------------------------    /**     * @inheritDoc     */    public function get transformer():IViewportTransformer    {        return viewport.transformer    }    /**     * @inheritDoc     */    public function set transformer(value:IViewportTransformer):void    {    	viewport.transformer = value    }    //----------------------------------    //  transform    //----------------------------------    /**     * @private     * Storage for the transform property.     *///    private var _transform:IViewportTransform////   ;[Bindable(event="transformUpdate")]////    /**//     * @inheritDoc//     *///    public function get transform():IViewportTransform//    {//        return _transform.clone()//    }////    public function set transform(value:IViewportTransform):void//    {//        var oldTransform:IViewportTransform = _transform.clone()//        _transform = value.clone()//        dispatchUpdateTransformEvent(oldTransform)//    }    //----------------------------------    //  scene    //----------------------------------    /**     * @inheritDoc     */    public function get scene():IReadonlyMultiScaleScene    {        return viewport.scene    }    //----------------------------------    //  viewportWidth    //----------------------------------    [Bindable(event="resize")]    /**     * @inheritDoc     */    public function get viewportWidth():Number    {        return viewport.viewportWidth    }    //----------------------------------    //  viewportHeight    //----------------------------------    [Bindable(event="resize")]    /**     * @inheritDoc     */    public function get viewportHeight():Number    {        return viewport.viewportHeight    }    //--------------------------------------------------------------------------    //    //  Methods: Zooming    //    //--------------------------------------------------------------------------    /**     * @inheritDoc     */    public function zoomTo(zoom:Number,                           transformX:Number=NaN,                           transformY:Number=NaN,                           immediately:Boolean=false):void    {    	if (isNaN(transformX))    	   transformX = scene.sceneWidth / 2    	    	if (isNaN(transformY))    	   transformY = scene.sceneHeight / 2       	    	viewport.zoomTo(zoom,    	                transformX / scene.sceneWidth,    	                transformY / scene.sceneHeight,    	                immediately)    }    /**     * @inheritDoc     */    public function zoomBy(factor:Number,                           transformX:Number=NaN,                           transformY:Number=NaN,                           immediately:Boolean = false):void    {        if (isNaN(transformX))           transformX = scene.sceneWidth / 2                if (isNaN(transformY))           transformY = scene.sceneHeight / 2                   viewport.zoomBy(factor,                        transformX / scene.sceneWidth,                        transformY / scene.sceneHeight,                        immediately)            }    //--------------------------------------------------------------------------    //    //  Methods: Panning    //    //--------------------------------------------------------------------------    /**     * @inheritDoc     */    public function panTo(x:Number, y:Number,                          immediately:Boolean = false):void    {    	viewport.panTo(x / scene.sceneWidth,    	               y / scene.sceneHeight,    	               immediately)    }    /**     * @inheritDoc     */    public function panBy(deltaX:Number, deltaY:Number,                          immediately:Boolean=false):void    {    	viewport.panBy(deltaX / scene.sceneWidth,    	               deltaY / scene.sceneHeight,    	               immediately)    }    /**     * @inheritDoc     */    public function panCenterTo(centerX:Number, centerY:Number,                                immediately:Boolean=false):void    {    	viewport.panCenterTo(centerX / scene.sceneWidth,    	                     centerY / scene.sceneHeight,    	                     immediately)    }    /**     * @inheritDoc     */    public function fitToBounds(bounds:Rectangle,                                scale:Number=1.0,                                immediately:Boolean = false):void    {    	bounds.x /= scene.sceneWidth    	bounds.y /= scene.sceneHeight    	bounds.width /= scene.sceneWidth    	bounds.height /= scene.sceneHeight    	    	viewport.fitToBounds(bounds, scale, immediately)    }    /**     * @inheritDoc     */    public function showAll(immediately:Boolean=false):void    {    	viewport.showAll(immediately)    }    //--------------------------------------------------------------------------    //    //  Methods: Coordinate transformations    //    //--------------------------------------------------------------------------    /**     * @inheritDoc     */    public function localToScene(point:Point):Point    {    	point.x /= viewportWidth    	point.y /= viewportHeight    	var p:Point = viewport.localToScene(point)    	p.x *= scene.sceneWidth    	p.y *= scene.sceneHeight    	    	return p    }    /**     * @inheritDoc     */    public function sceneToLocal(point:Point):Point    {        point.x /= scene.sceneWidth        point.y /= scene.sceneHeight        var p:Point = viewport.sceneToLocal(point)        p.x *= viewportWidth        p.y *= viewportHeight                return p    }    //--------------------------------------------------------------------------    //    //  Methods: IViewport / flash.geom.Rectangle    //    //--------------------------------------------------------------------------    /**     * @inheritDoc     */    public function getBounds():Rectangle    {    	return new Rectangle(x, y, width, height)    }    /**     * @inheritDoc     */    public function contains(x:Number, y:Number):Boolean    {        // FIXME: Delegate to Rectangle object.        return (x >= left) && (x <= right) && (y >= top) && (y <= bottom)    }    /**     * @inheritDoc     */    public function intersects(toIntersect:Rectangle):Boolean    {    	// TODO    	        // FIXME: Circumvent normalization / denormalization        var sceneViewport:Rectangle = new Rectangle(x * scene.sceneWidth,                                                    y * scene.sceneHeight,                                                    width * scene.sceneWidth,                                                    height * scene.sceneHeight)        return sceneViewport.intersects(denormalizeRectangle(toIntersect))//        var bounds:Rectangle = new Rectangle(x, y, width, height)//        return bounds.intersects(toIntersect)    }    /**     * @inheritDoc     */    public function intersection(toIntersect:Rectangle):Rectangle    {        // TODO    	        // FIXME: Circumvent normalization / denormalization        var sceneViewport:Rectangle = new Rectangle(x * scene.sceneWidth,                                                      y * scene.sceneHeight,                                                      width * scene.sceneWidth,                                                      height * scene.sceneHeight)        return sceneViewport.intersection(denormalizeRectangle(toIntersect))//        var bounds:Rectangle = new Rectangle(x, y, width, height)//        return bounds.intersection(toIntersect)    }    //--------------------------------------------------------------------------    //    //  Properties: IViewport    //    //--------------------------------------------------------------------------    //----------------------------------    //  x    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get x():Number    {        return viewport.x * scene.sceneWidth    }    public function set x(value:Number):void    {    	viewport.x = value / scene.sceneWidth    }    //----------------------------------    //  y    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get y():Number    {       return viewport.y * scene.sceneHeight    }    public function set y(value:Number):void    {    	viewport.y = value / scene.sceneHeight    }    //----------------------------------    //  width    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get width():Number    {        return viewport.width * scene.sceneWidth    }    public function set width(value:Number):void    {    	viewport.width = value / scene.sceneWidth    }    //----------------------------------    //  height    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get height():Number    {        return viewport.height * scene.sceneHeight    }    public function set height(value:Number):void    {    	viewport.height = value / scene.sceneHeight    }    //----------------------------------    //  left    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get left():Number    {        return viewport.left * scene.sceneWidth    }    //----------------------------------    //  right    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get right():Number    {    	return viewport.right * scene.sceneWidth    }      //----------------------------------    //  top    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get top():Number    {        return viewport.top * scene.sceneHeight    }    //----------------------------------    //  bottom    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get bottom():Number    {        return viewport.bottom * scene.sceneHeight    }    //----------------------------------    //  topLeft    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get topLeft():Point    {    	var p:Point = viewport.topLeft    	p.x *= scene.sceneWidth    	p.y *= scene.sceneHeight    	        return p     }    //----------------------------------    //  bottomRight    //----------------------------------    [Bindable(event="transformUpdate")]    /**     * @inheritDoc     */    public function get bottomRight():Point    {        var p:Point = viewport.topLeft        p.x *= scene.sceneWidth        p.y *= scene.sceneHeight                return p     }    //--------------------------------------------------------------------------    //    //  Methods: Transform Events    //    //--------------------------------------------------------------------------    /**     * @inheritDoc     *///    public function beginTransform():void//    {//        dispatchEvent(new ViewportEvent(ViewportEvent.TRANSFORM_START))//    }    /**     * @private     * Dispatches a transformUpdate event along with a copy     * of the transform previously applied to this viewport.     *///    private function dispatchUpdateTransformEvent(oldTransform:IViewportTransform//                                                       = null):void//    {//        dispatchEvent(new ViewportEvent(ViewportEvent.TRANSFORM_UPDATE,//                           false, false, oldTransform))//    }    /**     * @inheritDoc     *///    public function endTransform():void//    {//        dispatchEvent(new ViewportEvent(ViewportEvent.TRANSFORM_END))//    }    //--------------------------------------------------------------------------    //    //  Methods: Internal    //    //--------------------------------------------------------------------------    /**     * @private     *///    private function getTargetTransform():IViewportTransform//    {//        var t:IViewportTransform = transformer.target//        return t//    }    /**     * @private     *///    private function applyTransform(transform:IViewportTransform,//                                    immediately:Boolean=false):void//    {//        transformer.transform(transform, immediately)//        dispatchEvent(new ViewportEvent(ViewportEvent.TARGET_UPDATE))//    }    /**     * @private     *///    private function reinitializeTransform(viewportWidth:Number,//                                            viewportHeight:Number):void//    {//        var old:IViewportTransform = transform//        var t:IViewportTransformContainer =//                ViewportTransform.fromValues(old.x, old.y,//                                             old.width, old.height, old.zoom,//                                             viewportWidth, viewportHeight,//                                             _scene.sceneWidth, _scene.sceneHeight)//        applyTransform(t, true)//    }    //--------------------------------------------------------------------------    //    //  Methods: IViewportContainer    //    //--------------------------------------------------------------------------    /**     * @inheritDoc     *///    public function setSize(width:Number, height:Number):void//    {//        if (viewportWidth == width && viewportHeight == height)//            return////        reinitializeTransform(width, height)////        var resizeEvent:ViewportEvent =//                new ViewportEvent(ViewportEvent.RESIZE, false, false)//        dispatchEvent(resizeEvent)//    }    //--------------------------------------------------------------------------    //    //  Methods: Coordinate conversion    //    //--------------------------------------------------------------------------    /**     * @private     */    private function normalizeX(value:Number):Number    {        return value / scene.sceneWidth    }    /**     * @private     */    private function normalizeY(value:Number):Number    {        return value / scene.sceneHeight    }    /**     * @private     */    private function normalizeRectangle(value:Rectangle):Rectangle    {        return new Rectangle(normalizeX(value.x),                             normalizeY(value.y),                             normalizeX(value.width),                             normalizeY(value.height))    }    /**     * @private     */    private function normalizePoint(value:Point):Point    {        return new Point(normalizeX(value.x),                         normalizeY(value.y))    }    /**     * @private     */    private function denormalizeX(value:Number):Number    {        return value * scene.sceneWidth    }    /**     * @private     */    private function denormalizeY(value:Number):Number    {        return value * scene.sceneHeight    }    /**     * @private     */    private function denormalizePoint(value:Point):Point    {        return new Point(denormalizeX(value.x),                         denormalizeY(value.y))    }    /**     * @private     */    private function denormalizeRectangle(value:Rectangle):Rectangle    {        return new Rectangle(denormalizeX(value.x),                             denormalizeY(value.y),                             denormalizeX(value.width),                             denormalizeY(value.height))    }    //--------------------------------------------------------------------------    //    //  Event handlers    //    //--------------------------------------------------------------------------    /**     * @private     *///    private function scene_resizeHandler(event:Event):void//    {//        reinitializeTransform(viewportWidth, viewportHeight)//    }    //--------------------------------------------------------------------------    //    //  Methods: Debug    //    //--------------------------------------------------------------------------    /**     * @inheritDoc     */    override public function toString():String    {        return "[SceneViewport]" + "\n"               + "x=" + x + "\n"               + "y=" + y  + "\n"               + "z=" + zoom + "\n"               + "w=" + width + "\n"               + "h=" + height + "\n"               + "sW=" + scene.sceneWidth + "\n"               + "sH=" + scene.sceneHeight    }}}