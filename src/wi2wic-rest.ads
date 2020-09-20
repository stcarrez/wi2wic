-----------------------------------------------------------------------
--  wi2wic-rest -- REST entry points
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
with Servlet.Core;
private with Wiki.Documents;
private with Servlet.Requests;
private with Servlet.Responses;
private with Servlet.Rest;
private with Servlet.Streams;
package Wi2wic.Rest is

   procedure Register (Server : in out Servlet.Core.Servlet_Registry'Class);

private

   function Get_Syntax (Name : in String) return Wiki.Wiki_Syntax;

   procedure Render_Html (Doc    : in out Wiki.Documents.Document;
                          Output : in out Servlet.Rest.Output_Stream'Class);

   procedure Render_Doc (Doc    : in out Wiki.Documents.Document;
                         Syntax : in Wiki.Wiki_Syntax;
                         Output : in out Servlet.Rest.Output_Stream'Class);

   procedure Import_Doc (Doc    : in out Wiki.Documents.Document;
                         Syntax : in Wiki.Wiki_Syntax;
                         Stream : in out Servlet.Streams.Input_Stream'Class);

   --  Import an HTML content by getting the HTML content from a URL
   --  and convert to the target wiki syntax.
   procedure Import (Req     : in out Servlet.Requests.Request'Class;
                     Reply   : in out Servlet.Responses.Response'Class;
                     Stream  : in out Servlet.Rest.Output_Stream'Class);

   --  Convert a Wiki text from one format to another.
   procedure Convert (Req     : in out Servlet.Requests.Request'Class;
                      Reply   : in out Servlet.Responses.Response'Class;
                      Stream  : in out Servlet.Rest.Output_Stream'Class);

   --  Render the Wiki content in HTML.
   procedure Render (Req     : in out Servlet.Requests.Request'Class;
                     Reply   : in out Servlet.Responses.Response'Class;
                     Stream  : in out Servlet.Rest.Output_Stream'Class);

end Wi2wic.Rest;
