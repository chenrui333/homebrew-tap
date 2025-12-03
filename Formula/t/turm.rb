class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "390a7a295b4bfcc52cdbad69c3597b042dbc2a44190594b74940f048e3592eab"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"turm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/turm --version")
  end
end
