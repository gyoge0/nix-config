{ ... }:
{
  flake.modules = {
    homeManager.ideavim =
      { ... }:
      {
        # ideavim isn't as in depth as vim, so we just set up with raw files
        # ideavim also needs vimrc, and right now there isn't a super easy way to convertn nixvim into a vimrc
        # final bit that's important is we are actually making a temp file and copying it into place
        # this is because we might want to edit one of the files on the fly, which home manager's symlinks can't allow
        # note that any edits will not be persisted
        home.file.".vimrc" = {
          enable = true;
          force = false;
          target = ".vimrc.tmp";
          onChange = ''
            if [ -e ~/.vimrc ]; then
                rm ~/.vimrc
            fi
            cp ~/.vimrc.tmp ~/.vimrc
            rm ~/.vimrc.tmp
            chown gyoge .vimrc
          '';
          text = ''
            let mapleader = "m"


            filetype plugin on


            " store backup, undo, and swap files in temp directory
            set directory=/tmp/
            set backupdir=/tmp/
            set undodir =/tmp/


            " Quick open and reload the vimrc
            nnoremap \e :e ~/.vimrc<CR>
            nnoremap \r :source ~/.vimrc<CR>


            " Numbering
            set number relativenumber


            " show existing tab with 4 spaces width
            set tabstop=4
            " when indenting with '>', use 4 spaces width
            set shiftwidth=4
            " On pressing tab, insert 4 spaces
            set expandtab


            set softtabstop=4
            set autoindent
            set backspace=indent,eol,start


            " Maintain indentation
            set autoindent


            " Disable tone
            set belloff=all


            " No wrap
            set nowrap


            " Automatically set current file as relative dir
            set autochdir


            set nohlsearch


            " <leader>o for new line below (keep cursor on same line)
            " <leader>O for new line above (cursor should move down one)
            nnoremap <leader>o O<Esc>
            nnoremap <leader>O o<Esc>


            " Split movements
            nnoremap <a-h> <c-w>h
            nnoremap <a-l> <c-w>l
            nnoremap <a-j> <c-w>j
            nnoremap <a-k> <c-w>k


            " tabs
            nnoremap <tab> gt
            nnoremap <s-tab> gT
          '';
        };
        home.file.".ideavimrc" = {
          enable = true;
          force = false;
          target = ".ideavimrc.tmp";
          onChange = ''
            if [ -e ~/.ideavimrc ]; then
                rm ~/.ideavimrc
            fi
            cp ~/.ideavimrc.tmp ~/.ideavimrc
            rm ~/.ideavimrc.tmp
            chown gyoge .ideavimrc
          '';
          text = ''
            " Use regular _vimrc
            source ~/.vimrc


            " Plugins
            Plug 'preservim/nerdtree'
            Plug 'tpope/vim-surround'
            Plug 'kana/vim-textobj-entire'
            Plug 'machakann/vim-highlightedyank'
            Plug 'terryma/vim-multiple-cursors'
            Plug 'tommcdo/vim-exchange'


            set surround
            set relativenumber
            "set norelativenumber
            set easymotion
            set ideajoin
            set ideaput


            " No bell sound
            set visualbell
            set noerrorbells


            "set scrolloff=7
            set scrolloff=0


            nnoremap \e :e ~/.ideavimrc<CR>
            nnoremap \r :source ~/.ideavimrc<CR>


            " View modes
            nnoremap <c-z> :action ToggleZenMode<CR>
            nnoremap <c-x> :action ToggleFullScreen<CR>


            " Source editing
            nnoremap [[ :action MethodUp<CR>
            nnoremap ]] :action MethodDown<CR>


            nnoremap <leader>e :action CollapseRegion<CR>
            nnoremap <leader>E :action ExpandRegion<CR>


            nnoremap ge :action GotoNextError<CR>
            nnoremap gE :action GotoPreviousError<CR>


            nnoremap <leader>r :action Refactorings.QuickListPopupAction<CR>
            nnoremap <leader>l :action ReformatCode<CR>


            " Go to x
            nnoremap gc :action GotoClass<CR>
            nnoremap gi :action GotoImplementation<CR>
            nnoremap gd :action GotoDeclaration<CR>
            nnoremap gp :action GotoSuperMethod<CR>
            nnoremap gb :action Back<CR>
            nnoremap gf :action Forward<CR>


            " Moving around tabs
            sethandler <s-TAB> a:vim
            nnoremap <s-TAB> :action PreviousTab<CR>
            noremap <TAB> :action NextTab<CR>


            " Run
            nnoremap ,r :action Run<CR>
            "nnoremap ,r :action DevKit.ApplyTheme<CR>
            nnoremap ,d :action Debug<CR>
            nnoremap ,c :action RunClass<CR>
            nnoremap ,s :action Stop<CR>
            nnoremap ,f :action ChooseRunConfiguration<CR>
            nnoremap ,b :action CompileDirty<CR>
            "nnoremap ,b :action BuildSolutionAction<CR>
            "nnoremap ,b :action Build<CR>




            " Render comments
            nnoremap <leader>q :action ToggleRenderedDocPresentationForAll<CR>
            nnoremap <leader>Q :action ToggleRenderedDocPresentation<CR>


            " Tool windows
            nnoremap .e :action ActivateProjectToolWindow<CR>
            nnoremap .p :action ActivateProblemsViewToolWindow<CR>
            nnoremap .t :action ActivateTerminalToolWindow<CR>
            nnoremap .r :action ActivateRunToolWindow<CR>
            nnoremap .d :action ActivateDebugToolWindow<CR>
            nnoremap .b :action ActivateBuildToolWindow<CR>
            nnoremap .c :action ActivateCommitToolWindow<CR>
            nnoremap .g :action ActivateVersionControlToolWindow<CR>
            nnoremap .v :action ActivateServicesToolWindow<CR>
            nnoremap .w :action ActivatePythonConsoleToolWindow<CR>
            nnoremap .j :action ActivateJupyterToolWindow<CR>


            nnoremap .<S-ESC> :action HideAllWindows<CR>


            " debugger
            nnoremap <leader>dr :action Resume<CR>
            nnoremap <leader>di :action StepInto<CR>
            nnoremap <leader>dI :action StepOut<CR>
            nnoremap <leader>do :action StepOver<CR>
            nnoremap <leader>dd :action ToggleLineBreakpoint<CR>
            nnoremap <leader>dD :action Debugger.RemoveAllBreakpoints<CR>


            " . takes forever, so we just use ..
            nnoremap .. .


            " preview window stuff
            " nnoremap <leader>v :action xaml.splitEditor.editorActions.EditorOnlyAction<CR>
            " nnoremap <leader>c :action xaml.splitEditor.editorActions.EditorAndPreviewAction<CR>
            nnoremap <leader>v :action Markdown.Layout.EditorOnly<CR>
            nnoremap <leader>c :action Markdown.Layout.EditorAndPreview<CR>


            " new cell for python
            nnoremap mcc o<Esc>0i# %%<Esc>o<Esc>


            " Intentions
            nnoremap <Space> :action ShowIntentionActions<CR>


            " Generate stuff
            nnoremap <leader>i :action Generate<CR>
          '';
        };
      };
  };
}
