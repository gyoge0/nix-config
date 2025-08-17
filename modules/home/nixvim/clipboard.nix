{ inputs, ... }:
{
  flake.modules.homeManager.nixvim.programs.nixvim = {
    extraConfigLuaPost = ''
      if string.match(vim.loop.os_uname().release, 'WSL2') then
        vim.g.clipboard = {
          copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
          },
          paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
          },
        }
      end
    '';
  };
}
