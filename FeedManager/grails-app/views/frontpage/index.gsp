<%@ page import="groovy.time.*" %>
<%@ page import="com.k_int.feedmanager.utils.DurationFormatter" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="main" />
    <g:javascript>
    $(document).ready(function()
  {  
    $('.home').addClass('active');
    $('img[title]').qtip(
    {
      position: 
      {
          my: 'top center',  // Position my top right...
          at: 'bottom center', // at the top center of...
       },
       style:
       {
         classes: 'ui-tooltip-rounded ui-tooltip-dark'
       },
       hide: 
       {
            fixed: true
         }
    });
  });
  </g:javascript>
  </head>

  <body>
<h1>Course Data Feed Manager</h1>
<div class="paginateButtons">
  <g:if test="${params.int('offset')}">
       Showing Feeds <em>${params.int('offset') + 1} - ${feedsTotal < (params.int('max') + params.int('offset')) ? feedsTotal : (params.int('max') + params.int('offset'))}</em> of <em>${feedsTotal}</em>
  </g:if>
  <g:elseif test="${feedsTotal && feedsTotal > 0}">
    Showing Feeds <em>1 - ${feedsTotal < params.int('max') ? feedsTotal : params.int('max')}</em> of <em>${feedsTotal}</em>
  </g:elseif>
  <g:else>
    Showing <em>${feedsTotal}</em> Feeds
  </g:else>
  <span><g:paginate params="${params}" next="&nbsp;" prev="&nbsp;" maxsteps="1" total="${feedsTotal}" /></span>
</div>
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Active</th>
      <th>Type</th>
      <th>Last Harvest</th>
      <th>Next Harvest</th>
      <th>Published?</th>
      <th>Status</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${feeds}" var="feed">
      <tr>
        <td class="ellipsis-overflow">${feed.feedname}</td>
        <td><g:img dir="images/table" file="${feed.active}.png" class="centered" /></td>
        <td>${feed.feedtype}</td>
        <td>
          <g:if test="${feed.lastCheck}"><g:formatDate format="dd MMM HH:mm" date="${feed.lastCheck}"/></g:if>
          <g:else>Never</g:else>
        </td>
        <td>
          <g:if test="${feed.lastCheck && feed.checkInterval}">${use(DurationFormatter){TimeCategory.minus(new Date(feed.lastCheck+feed.checkInterval), new Date()).toString()}}</g:if>
          <g:else>Unknown</g:else>
        </td>
        <td>
          <g:if test="${(feed.publicationStatus != null ) && (feed.publicationStatus == 1) }">Yes</g:if>
          <g:else>No</g:else>
        </td>
        <td>
          <g:if test="${feed.status == 3 && feed.statusMessage.find(/code:[1-9]/)}">
            <g:img dir="images/table" file="error.png" class="centered" title="${feed.statusMessage}"/>
          </g:if>
          <g:else>
            <g:img dir="images/table" file="status-${feed.status}.png" class="centered" title="${feed.statusMessage}"/>
          </g:else>
        </td>
      </tr>
     </g:each>
     </tbody>
     </table>
  </body>
</html>
