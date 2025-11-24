class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "4398d76a41f66c0892e00136f7d9804b95f2f25b48c6f913bdab9e1e175baed7"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filessh --version")
    assert_match "You must provide a host", shell_output("#{bin}/filessh connect 2>&1", 1)
  end
end
