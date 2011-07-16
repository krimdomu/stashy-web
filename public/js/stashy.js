/*
 * Stashy JS
 */

$stashy = {

   get_system_info: function(id, itm) {
      $(".list_item").removeClass("active");
      $(itm).addClass("active");

      $.get("/server/get_information/" + id, function(data) {
         $("#server_details").html(data);
         $("#server_details").css("visibility", "visible");
      });
   }

};

