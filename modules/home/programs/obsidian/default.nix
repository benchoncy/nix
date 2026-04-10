{ pkgs, ... }:

let
  plugins = import ./plugins { inherit pkgs; };
in
{
  programs.obsidian = {
    enable = true;

    vaults."Documents/Obsidian/main".enable = true;

    defaultSettings = {
      app = {
        defaultViewMode = "preview";
        livePreview = false;
        readableLineLength = true;
        newFileLocation = "folder";
        newFileFolderPath = "inbox";
        attachmentFolderPath = "./attachments";
      };

      corePlugins = [
        { name = "daily-notes"; settings = { folder = "journal"; template = "_config/templates/Journal entry"; format = "YYYY/MM-MMM/YYYY-MM-DD"; autorun = false; }; }
        { name = "templates"; settings = { folder = "_config/templates"; dateFormat = ""; }; }
        { name = "graph"; }
        { name = "backlink"; }
        { name = "bookmarks"; }
        { name = "command-palette"; }
        { name = "file-recovery"; }
        { name = "file-explorer"; }
        { name = "outgoing-link"; }
        { name = "outline"; }
        { name = "page-preview"; }
        { name = "switcher"; }
        { name = "global-search"; }
        { name = "random-note"; }
        { name = "word-count"; }
        { name = "workspaces"; }
      ];

      communityPlugins = [
        { pkg = plugins.advanced-tables; enable = true; }
        { pkg = plugins.auto-link-title; enable = true; }
        { pkg = plugins.languagetool-integration; enable = true; }
        { pkg = plugins.local-rest-api; enable = true; }
        { pkg = plugins.remotely-save; enable = true; }
        {
          pkg = plugins.zotero-integration;
          enable = true;
          settings = {
            database = "Zotero";
            noteImportFolder = "inbox/";
            citeFormats = [
              {
                name = "Insert APA";
                format = "formatted-bibliography";
                cslStyle = "apa";
              }
            ];
            exportFormats = [
              {
                name = "Import Source";
                outputPathTemplate = "inbox/{{citekey}}.md";
                imageOutputPathTemplate = "assets/{{citekey}}/";
                imageBaseNameTemplate = "image";
                templatePath = "_config/zoteroplugin/templates/source.md";
                cslStyle = "apa";
              }
            ];
            citeSuggestTemplate = "[[{{citekey}}]]";
            openNoteAfterImport = true;
            whichNotesToOpenAfterImport = "first-imported-note";
          };
        }
      ];
    };
  };
}
