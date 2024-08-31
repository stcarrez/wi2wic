-----------------------------------------------------------------------
--  wi2wic -- wi2wic applications
--  Copyright (C) 2020 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--  SPDX-License-Identifier: Apache-2.0
-----------------------------------------------------------------------

with Util.Log.Loggers;

package body Wi2wic.Applications is

   Log     : constant Util.Log.Loggers.Logger := Util.Log.Loggers.Create ("Wi2wic");

   --  ------------------------------
   --  Configures the REST application so that it is ready to handler REST
   --  operations as well as give access to the Swagger UI that describes them.
   --  ------------------------------
   not overriding
   procedure Configure (App    : in out Application_Type;
                        Config : in Util.Properties.Manager'Class) is
      Cfg        : Util.Properties.Manager;
   begin
      Log.Info ("Initializing application servlets...");

      Cfg.Copy (Config);
      App.Set_Init_Parameters (Cfg);

      --  Register the servlets and filters
      App.Add_Servlet (Name => "api", Server => App.Api'Unchecked_Access);
      App.Add_Servlet (Name => "files", Server => App.Files'Unchecked_Access);

      App.Add_Filter (Name => "dump", Filter => App.Dump'Unchecked_Access);
      App.Add_Filter (Name => "measures", Filter => App.Measures'Unchecked_Access);
      App.Add_Filter (Name => "no-cache", Filter => App.No_Cache'Unchecked_Access);

      --  Define servlet mappings
      App.Add_Mapping (Name => "api", Pattern => "/*");

      App.Add_Mapping (Name => "files", Pattern => "*.html");
      App.Add_Mapping (Name => "files", Pattern => "*.js");
      App.Add_Mapping (Name => "files", Pattern => "*.png");
      App.Add_Mapping (Name => "files", Pattern => "*.css");
      App.Add_Mapping (Name => "files", Pattern => "*.svg");
      App.Add_Mapping (Name => "files", Pattern => "*.map");
      App.Add_Mapping (Name => "files", Pattern => "*.jpg");
   end Configure;

end Wi2wic.Applications;
