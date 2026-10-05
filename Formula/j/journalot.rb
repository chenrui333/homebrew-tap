class Journalot < Formula
  desc "Minimal journaling CLI for developers"
  homepage "https://github.com/jtaylortech/journalot"
  url "https://github.com/jtaylortech/journalot/archive/refs/tags/v5.6.2.tar.gz"
  sha256 "ccd9bc43020bfe7f20becf94bd2edc74a4f2b77074566fab3c8b84def99c3c92"
  license "MIT"
  head "https://github.com/jtaylortech/journalot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e0e5676f24869af9afc8c495f45e792ae48f618cbda914cbdaa82074026cba4b"
  end

  depends_on "bash"

  deny_network_access!

  def install
    inreplace "bin/journal", "#!/usr/bin/env bash", "#!#{formula_opt_bin("bash")}/bash"
    bin.install "bin/journal"
    bin.install_symlink bin/"journal" => "journalot"
  end

  test do
    require "date"
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    journal_dir = testpath/"journal"
    config_dir = testpath/"config"
    today = Date.today.strftime("%Y-%m-%d")
    entry = journal_dir/"entries/#{today}.md"

    env = "JOURNAL_DIR=#{journal_dir} XDG_CONFIG_HOME=#{config_dir} TERM=xterm"
    output = shell_output("#{env} #{bin}/journalot 'Had a great idea today'")
    assert_match "Added to #{today}.md", output
    assert_path_exists entry
    assert_match "Had a great idea today", entry.read
  end
end
