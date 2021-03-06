package com.k_int.xcri

import grails.converters.*

class CourseController {

  def ESWrapperService

  def index() { 
    log.debug("Course controller, params.id=${params.id}")

    def result = [:]

    // Get hold of some services we might use ;)
    def mongo = new com.gmongo.GMongo();
    def db = mongo.getDB("xcri")
    org.elasticsearch.groovy.node.GNode esnode = ESWrapperService.getNode()
    org.elasticsearch.groovy.client.GClient esclient = esnode.getClient()

    if ( params.id != null ) {
      // Form passed in a query


      def course = esclient.get {
          index "courses"
          type "course"
          id params.id
      }

      if ( course != null ) {
        result.course = course.response
        // def caj = course as JSON
        // log.debug("Got course ${caj}");
        
      }
      else {
        log.error("Id search matched ${search.response.hits.totalHits} items.");
        render(view:'notfound',model:result)
      }

      result
      
      withFormat {
          html {
            result
          }
          xml {
            render result as XML
          }
          json {
            render result as JSON
          }
        }
    }
    else {
      log.warn("No query.. Show search page")
      render(view:'notfound',model:result)
    }

  }
}
