class Ctxhist < Formula
  desc "Context-aware shell history extension for Bash and Zsh"
  homepage "https://github.com/nakkiy/ctxhist"
  url "https://github.com/nakkiy/ctxhist/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ae8f5a48d8ac535dcfc0d3cd920af14bb27ed138b44b1240710fc6a81fce5525"
  license "MIT"
  head "https://github.com/nakkiy/ctxhist.git", branch: "main"

  depends_on "bash"
  depends_on "fzf"

  def install
    pkgshare.install "ctxhist.bash", "ctxhist.plugin.zsh"

    (bin/"ctxhist-install").write <<~BASH
      #!#{Formula["bash"].opt_bin}/bash
      set -euo pipefail

      plugin_name="ctxhist"
      plugin_target_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
      plugin_target_file="$plugin_target_dir/$plugin_name.plugin.zsh"

      mkdir -p "$plugin_target_dir"
      cp "#{opt_pkgshare}/ctxhist.plugin.zsh" "$plugin_target_file"
      echo "Plugin file copied to $plugin_target_file"
    BASH
  end

  def caveats
    <<~EOS
      Bash:
        Add this line to your shell rc file:
          source #{opt_pkgshare}/ctxhist.bash

      Oh My Zsh:
        Run:
          ctxhist-install
        Then add `ctxhist` to your plugins list in ~/.zshrc.
    EOS
  end

  test do
    zsh_custom = testpath/"custom"
    zshrc = Pathname(Dir.home)/".zshrc"
    zshrc.write("plugins=(git)\n")

    output = shell_output("ZSH_CUSTOM=#{zsh_custom} #{bin}/ctxhist-install")
    plugin_file = zsh_custom/"plugins/ctxhist/ctxhist.plugin.zsh"

    assert_match "Plugin file copied", output
    assert_path_exists plugin_file
    assert_match "CTXHIST_LOG_FILE", plugin_file.read
  end
end
