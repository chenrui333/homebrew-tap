class Jocalsend < Formula
  desc "Rust terminal client for Localsend"
  homepage "https://git.kittencollective.com/nebkor/joecalsend"
  url "https://static.crates.io/crates/jocalsend/jocalsend-1.6.18033988.crate"
  sha256 "d967acd99a7b266bdec05ec8e2a8cc1f79ebbd425cb43efc0ca2f20a7f6096d6"
  # https://git.kittencollective.com/nebkor/joecalsend/src/branch/main/LICENSE.md
  # dual license
  # license :unfree

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
