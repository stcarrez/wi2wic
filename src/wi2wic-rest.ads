-----------------------------------------------------------------------
--  wi2wic-rest -- REST entry points
--  Copyright (C) 2020 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--  SPDX-License-Identifier: Apache-2.0
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
