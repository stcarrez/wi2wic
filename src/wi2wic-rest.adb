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
with Wiki.Strings;
with Wiki.Streams;
with Wiki.Parsers;
with Wiki.Filters.Html;
with Wiki.Render.Html;
with Wiki.Render.Wiki;
with Wiki.Streams.Html.Stream;
with Util.Http.Clients;
with Util.Strings;
with Servlet.Rest.Operation;
package body Wi2wic.Rest is

   use type Wiki.Wiki_Syntax;

   URI_Prefix : constant String := "/v1";

   package API_Import is
      new Servlet.Rest.Operation (Handler => Import'Access,
                                  Method  => Servlet.Rest.POST,
                                  URI     => URI_Prefix & "/import/{target}");

   package API_Convert is
      new Servlet.Rest.Operation (Handler => Convert'Access,
                                  Method  => Servlet.Rest.POST,
                                  URI     => URI_Prefix & "/converter/{format}/{target}");

   package API_Render is
      new Servlet.Rest.Operation (Handler => Render'Access,
                                  Method  => Servlet.Rest.POST,
                                  URI     => URI_Prefix & "/render/{format}");

   Invalid_Format : exception;

   function Get_Syntax (Name : in String) return Wiki.Wiki_Syntax is
   begin
      if Name = "markdown" then
         return Wiki.SYNTAX_MARKDOWN;
      elsif Name = "dotclear" then
         return Wiki.SYNTAX_DOTCLEAR;
      elsif Name = "creoler" then
         return Wiki.SYNTAX_CREOLE;
      elsif Name = "mediawiki" then
         return Wiki.SYNTAX_MEDIA_WIKI;
      elsif Name = "html" then
         return Wiki.SYNTAX_HTML;
      else
         raise Invalid_Format;
      end if;
   end Get_Syntax;

   procedure Import_Doc (Doc    : in out Wiki.Documents.Document;
                         Syntax : in Wiki.Wiki_Syntax;
                         Stream : in out Servlet.Streams.Input_Stream'Class) is
      type Input_Stream is new Wiki.Streams.Input_Stream with null record;

      --  Read one character from the input stream and return False to the <tt>Eof</tt> indicator.
      --  When there is no character to read, return True in the <tt>Eof</tt> indicator.
      overriding
      procedure Read (Input : in out Input_Stream;
                      Char  : out Wiki.Strings.WChar;
                      Eof   : out Boolean);

      overriding
      procedure Read (Input : in out Input_Stream;
                      Char  : out Wiki.Strings.WChar;
                      Eof   : out Boolean) is
      begin
         Stream.Read (Char);
         Eof := Stream.Is_Eof;
      exception
         when others =>
            Eof := True;
      end Read;

      Html_Filter : aliased Wiki.Filters.Html.Html_Filter_Type;
      In_Stream   : aliased Input_Stream;
      Engine      : Wiki.Parsers.Parser;
   begin
      Html_Filter.Hide (Wiki.FOOTER_TAG);
      Html_Filter.Hide (Wiki.HEAD_TAG);
      Html_Filter.Hide (Wiki.HEADER_TAG);
      Html_Filter.Hide (Wiki.ADDRESS_TAG);
      Html_Filter.Hide (Wiki.IFRAME_TAG);
      Engine.Set_Syntax (Syntax);
      Engine.Add_Filter (Html_Filter'Unchecked_Access);
      Engine.Parse (In_Stream'Unchecked_Access, Doc);
   end Import_Doc;

   procedure Render_Doc (Doc    : in out Wiki.Documents.Document;
                         Syntax : in Wiki.Wiki_Syntax;
                         Output : in out Servlet.Rest.Output_Stream'Class) is

      type Output_Stream is limited new Wiki.Streams.Output_Stream with null record;

      --  Write the string to the output stream.
      overriding
      procedure Write (Stream  : in out Output_Stream;
                       Content : in Wiki.Strings.WString);

      --  Write a single character to the output stream.
      overriding
      procedure Write (Stream : in out Output_Stream;
                       Char   : in Wiki.Strings.WChar);

      --  Write the string to the output stream.
      overriding
      procedure Write (Stream  : in out Output_Stream;
                       Content : in Wiki.Strings.WString) is
      begin
         Output.Write_Wide (Content);
      end Write;

      --  Write a single character to the output stream.
      overriding
      procedure Write (Stream : in out Output_Stream;
                       Char   : in Wiki.Strings.WChar) is
      begin
         Output.Write_Wide (Char);
      end Write;

      Out_Stream : aliased Output_Stream;
      Renderer   : Wiki.Render.Wiki.Wiki_Renderer;
   begin
      Renderer.Set_Output_Stream (Out_Stream'Unchecked_Access, Syntax);
      Renderer.Render (Doc);
   end Render_Doc;

   procedure Render_Html (Doc    : in out Wiki.Documents.Document;
                          Output : in out Servlet.Rest.Output_Stream'Class) is

      type Output_Stream is limited new Wiki.Streams.Output_Stream with null record;

      --  Write the string to the output stream.
      overriding
      procedure Write (Stream  : in out Output_Stream;
                       Content : in Wiki.Strings.WString);

      --  Write a single character to the output stream.
      overriding
      procedure Write (Stream : in out Output_Stream;
                       Char   : in Wiki.Strings.WChar);

      --  Write the string to the output stream.
      overriding
      procedure Write (Stream  : in out Output_Stream;
                       Content : in Wiki.Strings.WString) is
      begin
         Output.Write_Wide (Content);
      end Write;

      --  Write a single character to the output stream.
      overriding
      procedure Write (Stream : in out Output_Stream;
                       Char   : in Wiki.Strings.WChar) is
      begin
         Output.Write_Wide (Char);
      end Write;

      package Html_Stream is
         new Wiki.Streams.Html.Stream (Output_Stream);

      Out_Stream : aliased Html_Stream.Html_Output_Stream;
      Renderer   : Wiki.Render.Html.Html_Renderer;
   begin
      Renderer.Set_Render_TOC (True);
      Renderer.Set_Output_Stream (Out_Stream'Unchecked_Access);
      Renderer.Render (Doc);
   end Render_Html;

   --  ------------------------------
   --  Import an HTML content by getting the HTML content from a URL
   --  and convert to the target wiki syntax.
   --  ------------------------------
   procedure Import (Req     : in out Servlet.Requests.Request'Class;
                     Reply   : in out Servlet.Responses.Response'Class;
                     Stream  : in out Servlet.Rest.Output_Stream'Class) is
      Doc      : Wiki.Documents.Document;
      Target   : constant String := Req.Get_Path_Parameter (1);
      URL      : constant String := Req.Get_Parameter ("url");
      Syntax   : Wiki.Wiki_Syntax;
      Download : Util.Http.Clients.Client;
      Content  : Util.Http.Clients.Response;
   begin
      Syntax := Get_Syntax (Target);

      if not Util.Strings.Starts_With (URL, "http://")
        and not Util.Strings.Starts_With (URL, "https://")
      then
         Reply.Set_Status (Util.Http.SC_BAD_REQUEST);
         return;
      end if;

      Download.Add_Header ("X-Requested-By", "wi2wic");
      Download.Set_Timeout (5.0);
      begin
         Download.Get (URL, Content);

      exception
         when Util.Http.Clients.Connection_Error =>
            Reply.Set_Status (Util.Http.SC_REQUEST_TIMEOUT);
            return;

         when others =>
            Reply.Set_Status (Util.Http.SC_EXPECTATION_FAILED);
            return;
      end;
      declare
         Html_Filter : aliased Wiki.Filters.Html.Html_Filter_Type;
         Engine      : Wiki.Parsers.Parser;
      begin
         Html_Filter.Hide (Wiki.FOOTER_TAG);
         Html_Filter.Hide (Wiki.HEAD_TAG);
         Html_Filter.Hide (Wiki.HEADER_TAG);
         Html_Filter.Hide (Wiki.ADDRESS_TAG);
         Html_Filter.Hide (Wiki.IFRAME_TAG);
         Engine.Set_Syntax (Wiki.SYNTAX_HTML);
         Engine.Add_Filter (Html_Filter'Unchecked_Access);
         Engine.Parse (Content.Get_Body, Doc);
      end;
      Render_Doc (Doc, Syntax, Stream);

   exception
      when Invalid_Format =>
         Reply.Set_Status (Util.Http.SC_NOT_FOUND);
   end Import;

   --  ------------------------------
   --  Convert a Wiki text from one format to another.
   --  ------------------------------
   procedure Convert (Req     : in out Servlet.Requests.Request'Class;
                      Reply   : in out Servlet.Responses.Response'Class;
                      Stream  : in out Servlet.Rest.Output_Stream'Class) is
      Doc    : Wiki.Documents.Document;
      Format : constant String := Req.Get_Path_Parameter (1);
      Target : constant String := Req.Get_Path_Parameter (2);
   begin
      Import_Doc (Doc, Get_Syntax (Format), Req.Get_Input_Stream.all);
      Render_Doc (Doc, Get_Syntax (Target), Stream);

   exception
      when Invalid_Format =>
         Reply.Set_Status (Util.Http.SC_NOT_FOUND);
   end Convert;

   --  ------------------------------
   --  Render the Wiki content in HTML.
   --  ------------------------------
   procedure Render (Req     : in out Servlet.Requests.Request'Class;
                     Reply   : in out Servlet.Responses.Response'Class;
                     Stream  : in out Servlet.Rest.Output_Stream'Class) is
      Doc    : Wiki.Documents.Document;
      Format : constant String := Req.Get_Path_Parameter (1);
   begin
      Import_Doc (Doc, Get_Syntax (Format), Req.Get_Input_Stream.all);
      Render_Html (Doc, Stream);

   exception
      when Invalid_Format =>
         Reply.Set_Status (Util.Http.SC_NOT_FOUND);
   end Render;

   procedure Register (Server : in out Servlet.Core.Servlet_Registry'Class) is
   begin
      Servlet.Rest.Register (Server, API_Convert.Definition);
      Servlet.Rest.Register (Server, API_Render.Definition);
      Servlet.Rest.Register (Server, API_Import.Definition);
   end Register;

end Wi2wic.Rest;
