class GitX < Formula
  desc "CLI extensions for Git that simplify common workflows"
  homepage "https://github.com/simeg/git-x"
  url "https://static.crates.io/crates/git-x/git-x-1.1.0.crate"
  sha256 "dac2f14a3f515d7be0793bdede677fcfabbae86429fbc61cc0df39521437589c"
  license "MIT"
  head "https://github.com/simeg/git-x.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "test@brew.sh"

    (testpath/"README.md").write("# test")
    system "git", "add", "README.md"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/git-x info")

    default_branch = OS.mac? ? "main" : "master"
    assert_match "Current branch: #{default_branch}", output
  end
end
