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
class Wi2wic {
    readonly inputFormat : HTMLSelectElement | null = <HTMLSelectElement>document.getElementById('wi2wic-input-format');
    readonly inputContent : HTMLTextAreaElement | null = <HTMLTextAreaElement>document.getElementById('wi2wic-input');
    readonly renderContent : HTMLElement | null = document.getElementById('wi2wic-render');
    readonly urlContent : HTMLInputElement | null = <HTMLInputElement>document.getElementById('wi2wic-url');
    readonly urlSubmit : HTMLInputElement | null = <HTMLInputElement>document.getElementById('wi2wic-submit');
    readonly fileSelector : HTMLInputElement | null = <HTMLInputElement>document.getElementById('wi2wic-file');
    currentFormat : string = "markdown";

    constructor() {
        if (this.inputFormat) {
            this.inputFormat.addEventListener("change", (event: Event) => {
                this.updateOutput(event);
            });
            this.currentFormat = this.inputFormat.value;
        }
        if (this.renderContent) {
            this.renderContent.addEventListener("scroll", (event: Event) => {
                if (this.inputContent && this.renderContent) {
                    this.inputContent.scrollTop = this.renderContent.scrollTop;
                }
            });            
        }
        if (this.inputContent) {
            this.inputContent.addEventListener("input", (event: Event) => {
                this.updateResult(this.inputContent ? this.inputContent.value : "");
            });
            this.inputContent.addEventListener("scroll", (event: Event) => {
                if (this.renderContent && this.inputContent) {
                    this.renderContent.scrollTop = this.inputContent.scrollTop;
                }
            });
        }
        if (this.urlSubmit) {
            this.urlSubmit.addEventListener("click", (event: Event) => {
                this.downloadUrl(event);
            });
        }
        if (this.fileSelector) {
            this.fileSelector.addEventListener("change", (event: Event) => {
                this.loadFile(event);
            });
        }
    }
    loadFile(event : Event) {
        if (this.fileSelector) {
            const files = this.fileSelector.files;
            if (files && files.length > 0) {
                const file = files[0];
                const reader = new FileReader();
                reader.addEventListener("load", (event : Event) => {
                    if (this.inputContent) {
                        const result : string | ArrayBuffer | null = reader.result as string;
                        if (result) {
                            this.inputContent.value = result;
                            this.updateResult(result);
                        }
                    }
                }, false);
                reader.readAsBinaryString(file);
            }
        }
    }
    downloadUrl(event : Event) {
        if (this.urlContent) {
            const url : string = this.urlContent.value;
            const sourceFormat : string = this.inputFormat ? this.inputFormat.value : "";
            const xmlhttp : XMLHttpRequest = new XMLHttpRequest();

            xmlhttp.onload = evt => {
                if (xmlhttp.status == 200 && this.inputContent) {
                    this.inputContent.value = xmlhttp.responseText;
                    this.updateResult(xmlhttp.responseText);
                }
            };
            xmlhttp.open("POST", "/wi2wic/v1/import/" + sourceFormat);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send("url=" + url);
        }
    }
    updateOutput(event : Event) {
        if (!this.inputContent) {
            return;
        }
        const sourceFormat : string = this.currentFormat;
        const targetFormat : string = this.inputFormat ? this.inputFormat.value : "";
        const content : string = this.inputContent.value;
        const xmlhttp : XMLHttpRequest = new XMLHttpRequest();

        xmlhttp.onload = evt => {
            if (xmlhttp.status == 200 && this.inputContent) {
                this.inputContent.value = xmlhttp.responseText;
                this.currentFormat = targetFormat;
                this.updateResult(xmlhttp.responseText);
            }
        };
        xmlhttp.open("POST", "/wi2wic/v1/converter/" + sourceFormat + "/" + targetFormat);
        xmlhttp.setRequestHeader("Content-type", "text/plain");
        xmlhttp.send(content);
    }
    updateResult(content : string) {
        const targetFormat : string = this.inputFormat ? this.inputFormat.value : "markdown";
        const xmlhttp : XMLHttpRequest = new XMLHttpRequest();

        xmlhttp.onload = (ev) => {
            if (xmlhttp.status == 200 && this.renderContent) {
                this.renderContent.innerHTML = xmlhttp.responseText;
            }
        };
        xmlhttp.open("POST", "/wi2wic/v1/render/" + targetFormat);
        xmlhttp.setRequestHeader("Content-type", "text/plain");
        xmlhttp.send(content);
    }
}
var controller = new Wi2wic();
