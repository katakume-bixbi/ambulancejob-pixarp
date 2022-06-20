
document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function (event) {
          if (event.data.type == 'showui') {
            $(".main").fadeIn(750);
          }
          if (event.data.type == 'hideui') {
            $(".main").fadeOut(750);
          }

          if (event.data.type == 'updateearlySpawnTimer') {
              if (event.data.time == 0) {
                $(".respawn").html('Przytrzymaj <span style="color:LightCoral; font-size: 1.1vw;"><b>[E]</b></span> aby przeteleportować się do szpitala (200$).');
              } else {
                $(".respawn").html('Będziesz mógł odrodzic się w szpitalu za <span style="color:LightCoral; font-size: 1.1vw;"><b>' + event.data.time + '</b></span> sekund.');
              }
           
          }
          
          if (event.data.type == 'updatebleedoutTimer') {
            if (event.data.time == 0) {
                $(".standup").html('Naciśnij <span style="color:LightCoral; font-size: 1.1vw;"><b>[H]</b></span> aby wstać.');
              } else {
                $(".standup").html('Będziesz mógł wstać za <span style="color:LightCoral; font-size: 1.1vw;"><b>' + event.data.time + '</b></span> sekund.');
              }
          }
        });
    };
};




