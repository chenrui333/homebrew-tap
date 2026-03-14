class OmpManager < Formula
  desc "TUI manager for Oh My Posh themes, fonts, and shell setup"
  homepage "https://github.com/marlocarlo/omp-manager"
  url "https://github.com/marlocarlo/omp-manager/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "c65be58e47d2e8348385c4c7df8569375dda2b9797845779cedb7d55447937bc"
  license "MIT"
  head "https://github.com/marlocarlo/omp-manager.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TERM"] = "xterm-256color"

    cmd = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin}/omp-manager"
    else
      "printf 'q' | script -q -c '#{bin}/omp-manager' /dev/null"
    end

    output = shell_output(cmd)
    assert_match(/\e\[\?1049h/, output)
    assert_match(/\e\[\?1049l/, output)
  end
end
