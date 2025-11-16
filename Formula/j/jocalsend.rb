class Jocalsend < Formula
  desc "Rust terminal client for Localsend"
  homepage "https://git.kittencollective.com/nebkor/joecalsend"
  url "https://static.crates.io/crates/jocalsend/jocalsend-1.6.18033988.crate"
  sha256 "d967acd99a7b266bdec05ec8e2a8cc1f79ebbd425cb43efc0ca2f20a7f6096d6"
  # https://git.kittencollective.com/nebkor/joecalsend/src/branch/main/LICENSE.md
  # dual license
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5a974dbe72ad43a90ca4c77fbfe63e6a30bf5785a326ce0a570137f8e97d352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6663ca9b5bbc3bb90cf807a98b78f25b74e56e35d1d93087acb2425516e2a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bd69dd116b90c4533186e2b910f7a47fe62bfec67202e7a9e7a972a99a13144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3c64a6bb876f657ac0d39a878794b25818d15f02946c1d415b1d159fc9c4e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8bf0a1176f7367bd711052447ef894ebe289f1f4af411c32d4a27f7a14d2bef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jocalsend --version")

    # Skip linux CI test
    # `Error: IOError(Os { code: 2, kind: NotFound, message: \"No such file or directory\" })`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jocalsend", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Incoming Transfer Requests", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
