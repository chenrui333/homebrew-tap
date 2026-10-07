class ZshViMan < Formula
  desc "Smart man page lookup plugin for Zsh vi and emacs modes"
  homepage "https://github.com/TunaCuma/zsh-vi-man"
  url "https://github.com/TunaCuma/zsh-vi-man/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6c81911514e3df20e889aad7490b1b464bcd188f9a8be3ac4ca6ca0f980b336b"
  license "MIT"
  head "https://github.com/TunaCuma/zsh-vi-man.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34c2509286c89ee523a19327436410dfee771118ee024ed1c54949db1bc66c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34c2509286c89ee523a19327436410dfee771118ee024ed1c54949db1bc66c64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93075d5e4bce6b23e648fba967a67a21af311615c74d516562224121bdd7422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93075d5e4bce6b23e648fba967a67a21af311615c74d516562224121bdd7422"
  end

  deny_network_access!

  def install
    pkgshare.install "zsh-vi-man.plugin.zsh", "zsh-vi-man.zsh", "lib"

    (bin/"zsh-vi-man-install").write <<~BASH
      #!#{which("bash")}
      set -euo pipefail

      plugin_name="zsh-vi-man"
      plugin_target_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"

      mkdir -p "$plugin_target_dir"
      cp "#{opt_pkgshare}/zsh-vi-man.plugin.zsh" "$plugin_target_dir/$plugin_name.plugin.zsh"
      cp "#{opt_pkgshare}/zsh-vi-man.zsh" "$plugin_target_dir/zsh-vi-man.zsh"
      cp -R "#{opt_pkgshare}/lib" "$plugin_target_dir/lib"
      echo "Plugin installed to $plugin_target_dir"
    BASH
  end

  def caveats
    <<~EOS
      Install into Oh My Zsh with:
        zsh-vi-man-install

      Then add `zsh-vi-man` to your plugins list in ~/.zshrc.

      For manual sourcing, use:
        source #{opt_pkgshare}/zsh-vi-man.plugin.zsh
    EOS
  end

  test do
    zsh_custom = testpath/"custom"
    output = shell_output("ZSH_CUSTOM=#{zsh_custom} #{bin}/zsh-vi-man-install")

    plugin_dir = zsh_custom/"plugins/zsh-vi-man"
    assert_match "Plugin installed", output
    assert_path_exists plugin_dir/"zsh-vi-man.plugin.zsh"
    assert_path_exists plugin_dir/"zsh-vi-man.zsh"
    assert_path_exists plugin_dir/"lib/parser.zsh"
  end
end
