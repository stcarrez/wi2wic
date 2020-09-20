"use strict";
/*
 *  wi2wic -- Wiki To Wiki Converter
 *  Copyright (C) 2020 Stephane Carrez
 *  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
var Wi2wic = /** @class */ (function () {
    function Wi2wic() {
        var _this = this;
        this.inputFormat = document.getElementById('wi2wic-input-format');
        this.inputContent = document.getElementById('wi2wic-input');
        this.renderContent = document.getElementById('wi2wic-render');
        this.urlContent = document.getElementById('wi2wic-url');
        this.urlSubmit = document.getElementById('wi2wic-submit');
        this.fileSelector = document.getElementById('wi2wic-file');
        this.currentFormat = "markdown";
        if (this.inputFormat) {
            this.inputFormat.addEventListener("change", function (event) {
                _this.updateOutput(event);
            });
            this.currentFormat = this.inputFormat.value;
        }
        if (this.renderContent) {
            this.renderContent.addEventListener("scroll", function (event) {
                if (_this.inputContent && _this.renderContent) {
                    _this.inputContent.scrollTop = _this.renderContent.scrollTop;
                }
            });
        }
        if (this.inputContent) {
            this.inputContent.addEventListener("input", function (event) {
                _this.updateResult(_this.inputContent ? _this.inputContent.value : "");
            });
            this.inputContent.addEventListener("scroll", function (event) {
                if (_this.renderContent && _this.inputContent) {
                    _this.renderContent.scrollTop = _this.inputContent.scrollTop;
                }
            });
        }
        if (this.urlSubmit) {
            this.urlSubmit.addEventListener("click", function (event) {
                _this.downloadUrl(event);
            });
        }
        if (this.fileSelector) {
            this.fileSelector.addEventListener("change", function (event) {
                _this.loadFile(event);
            });
        }
    }
    Wi2wic.prototype.loadFile = function (event) {
        var _this = this;
        if (this.fileSelector) {
            var files = this.fileSelector.files;
            if (files && files.length > 0) {
                var file = files[0];
                var reader_1 = new FileReader();
                reader_1.addEventListener("load", function (event) {
                    if (_this.inputContent) {
                        var result = reader_1.result;
                        if (result) {
                            _this.inputContent.value = result;
                            _this.updateResult(result);
                        }
                    }
                }, false);
                reader_1.readAsBinaryString(file);
            }
        }
    };
    Wi2wic.prototype.downloadUrl = function (event) {
        var _this = this;
        if (this.urlContent) {
            var url = this.urlContent.value;
            var sourceFormat = this.inputFormat ? this.inputFormat.value : "";
            var xmlhttp_1 = new XMLHttpRequest();
            xmlhttp_1.onload = function (evt) {
                if (xmlhttp_1.status == 200 && _this.inputContent) {
                    _this.inputContent.value = xmlhttp_1.responseText;
                    _this.updateResult(xmlhttp_1.responseText);
                }
            };
            xmlhttp_1.open("POST", "/wi2wic/v1/import/" + sourceFormat);
            xmlhttp_1.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp_1.send("url=" + url);
        }
    };
    Wi2wic.prototype.updateOutput = function (event) {
        var _this = this;
        if (!this.inputContent) {
            return;
        }
        var sourceFormat = this.currentFormat;
        var targetFormat = this.inputFormat ? this.inputFormat.value : "";
        var content = this.inputContent.value;
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onload = function (evt) {
            if (xmlhttp.status == 200 && _this.inputContent) {
                _this.inputContent.value = xmlhttp.responseText;
                _this.currentFormat = targetFormat;
                _this.updateResult(xmlhttp.responseText);
            }
        };
        xmlhttp.open("POST", "/wi2wic/v1/converter/" + sourceFormat + "/" + targetFormat);
        xmlhttp.setRequestHeader("Content-type", "text/plain");
        xmlhttp.send(content);
    };
    Wi2wic.prototype.updateResult = function (content) {
        var _this = this;
        var targetFormat = this.inputFormat ? this.inputFormat.value : "markdown";
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onload = function (ev) {
            if (xmlhttp.status == 200 && _this.renderContent) {
                _this.renderContent.innerHTML = xmlhttp.responseText;
            }
        };
        xmlhttp.open("POST", "/wi2wic/v1/render/" + targetFormat);
        xmlhttp.setRequestHeader("Content-type", "text/plain");
        xmlhttp.send(content);
    };
    return Wi2wic;
}());
var controller = new Wi2wic();
