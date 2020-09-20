-----------------------------------------------------------------------
--  wi2wic -- Wiki 2 Wiki Converter server startup
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
with Ada.IO_Exceptions;
with AWS.Config.Set;
with Servlet.Server.Web;
with Util.Strings;
with Util.Log.Loggers;
with Util.Properties;
with Util.Properties.Basic;
with Wi2wic.Rest;
with Wi2wic.Applications;
procedure Wi2wic.Server is
   procedure Configure (Config : in out AWS.Config.Object);

   use Util.Properties.Basic;

   CONFIG_PATH  : constant String := "wi2wic.properties";
   Port : Natural := 8080;

   procedure Configure (Config : in out AWS.Config.Object) is
   begin
      AWS.Config.Set.Server_Port (Config, Port);
      AWS.Config.Set.Max_Connection (Config, 8);
      AWS.Config.Set.Accept_Queue_Size (Config, 512);
   end Configure;

   App     : aliased Wi2wic.Applications.Application_Type;
   WS      : Servlet.Server.Web.AWS_Container;
   Log     : constant Util.Log.Loggers.Logger := Util.Log.Loggers.Create ("Wi2wic.Server");
   Props   : Util.Properties.Manager;
begin
   Props.Load_Properties (CONFIG_PATH);
   Util.Log.Loggers.Initialize (Props);

   Port := Integer_Property.Get (Props, "wi2wic.port", Port);
   App.Configure (Props);
   Wi2wic.Rest.Register (App);

   WS.Configure (Configure'Access);
   WS.Register_Application ("/wi2wic", App'Unchecked_Access);
   App.Dump_Routes (Util.Log.INFO_LEVEL);
   Log.Info ("Connect you browser to: http://localhost:{0}/wi2wic/index.html",
             Util.Strings.Image (Port));

   WS.Start;

   loop
      delay 6000.0;
   end loop;

exception
   when Ada.IO_Exceptions.Name_Error =>
      Log.Error ("Cannot read application configuration file {0}", CONFIG_PATH);
end Wi2wic.Server;
