// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CharacterSelectorController from "./character_selector_controller"
application.register("character-selector", CharacterSelectorController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import StarRatingController from "./star_rating_controller"
application.register("star-rating", StarRatingController)

import YoutubeStartController from "./youtube_start_controller"
application.register("youtube-start", YoutubeStartController)

import LoadingController from "./loading_controller"
application.register("loading", LoadingController)

import aos_frame_controller from "./aos_frame_controller"
application.register("aos-frame", aos_frame_controller)

import sidebar_controller from "./sidebar_controller"
application.register("sidebar", sidebar_controller)
