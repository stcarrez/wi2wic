-----------------------------------------------------------------------
--  wi2wic -- wi2wic applications
--  Copyright (C) 2020 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
-----------------------------------------------------------------------
with Util.Properties;
with Servlet.Filters.Dump;
with Servlet.Filters.Cache_Control;
with Servlet.Core.Files;
with Servlet.Core.Measures;
with Servlet.Core.Rest;

package Wi2wic.Applications is

   CONFIG_PATH  : constant String := "wi2wic";
   CONTEXT_PATH : constant String := "/wi2wic";

   type Application_Type is new Servlet.Core.Servlet_Registry with private;
   type Application_Access is access all Application_Type'Class;

   --  Configures the REST application so that it is ready to handler REST
   --  operations as well as give access to the Swagger UI that describes them.
   not overriding
   procedure Configure (App    : in out Application_Type;
                        Config : in Util.Properties.Manager'Class);

private

   type Application_Type is new Servlet.Core.Servlet_Registry with record
      Api                : aliased Servlet.Core.Rest.Rest_Servlet;
      Measures           : aliased Servlet.Core.Measures.Measure_Servlet;
      Files              : aliased Servlet.Core.Files.File_Servlet;
      No_Cache           : aliased Servlet.Filters.Cache_Control.Cache_Control_Filter;
      Dump               : aliased Servlet.Filters.Dump.Dump_Filter;
   end record;

end Wi2wic.Applications;
