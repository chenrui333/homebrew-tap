class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "3e26169f9968edd5005d7f2df9f7c4cf14b08c225d6766d9a51f3b6f73d42ca4"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fb5795064e86712fcb5eac81c528ea1697e58ee9335ca83a863bf0af535fb65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edad008329987501448f4e49055b46cbc7e493b5125adb04683f336e096377c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4cf313479e78accbf9c5a48d5472b1f09ee62b0977f01df150e2af4d4fd906f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030c4acd6770c1d5f60f61cca64f221dff4906b525ac3c113363527f1dffdfde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa3dc5440b15263b56d3511887a72cb235649aa66a55dbb1ed7f442b43690be"
  end

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
