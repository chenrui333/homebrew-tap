class Journalot < Formula
  desc "Minimal journaling CLI for developers"
  homepage "https://github.com/jtaylortech/journalot"
  url "https://github.com/jtaylortech/journalot/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "1c4f93eda09312891e3c3d8d1f7ed0844df4b7c3399407b99ec47f13dc20a188"
  license "MIT"
  head "https://github.com/jtaylortech/journalot.git", branch: "main"

  depends_on "bash"

  def install
    inreplace "bin/journal", "#!/usr/bin/env bash", "#!#{Formula["bash"].opt_bin}/bash"
    bin.install "bin/journal"
    bin.install_symlink bin/"journal" => "journalot"
  end

  test do
    require "date"

    journal_dir = testpath/"journal"
    config_dir = testpath/"config"
    today = Date.today.strftime("%Y-%m-%d")
    entry = journal_dir/"entries/#{today}.md"

    env = "JOURNAL_DIR=#{journal_dir} XDG_CONFIG_HOME=#{config_dir} TERM=xterm"
    output = shell_output("#{env} #{bin}/journalot 'Had a great idea today'")
    assert_match "Added to #{today}.md", output
    assert_path_exists entry
    assert_match "Had a great idea today", entry.read

    help = shell_output("#{bin}/journalot --help")
    assert_match "Minimal journaling CLI for developers", help
  end
end
