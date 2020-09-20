declare class Wi2wic {
    readonly inputFormat: HTMLSelectElement | null;
    readonly inputContent: HTMLTextAreaElement | null;
    readonly renderContent: HTMLElement | null;
    readonly urlContent: HTMLInputElement | null;
    readonly urlSubmit: HTMLInputElement | null;
    readonly fileSelector: HTMLInputElement | null;
    currentFormat: string;
    constructor();
    loadFile(event: Event): void;
    downloadUrl(event: Event): void;
    updateOutput(event: Event): void;
    updateResult(content: string): void;
}
declare var controller: Wi2wic;
