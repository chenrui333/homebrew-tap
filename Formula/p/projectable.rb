class Projectable < Formula
  desc "TUI file manager built for projects"
  homepage "https://dzfrias.dev/blog/projectable"
  url "https://github.com/dzfrias/projectable/archive/refs/tags/1.3.0.tar.gz"
  sha256 "fe1c0edf9f14f2cd9cfef7e9af921f3e4b307b5c518a7b79f96563d6269a1e72"
  license "MIT"
  head "https://github.com/dzfrias/projectable.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "715d53ebbbf72262e7d1c94239a521853deac49e026b4bd8075eebc906f5f9f2"
    sha256 cellar: :any,                 arm64_sonoma:  "9f41f17422af969aade1b112c29f3154c5fba8976dcfb2961690a86a039e1af7"
    sha256 cellar: :any,                 ventura:       "737d27c08055916144f720b9b94ea9929bc1cdb5ae1acf6ee8c61464cd52e73e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a6d4cace3cf6ccf6a6383ccbde929d4612970b6280765085d7916e6011ac4d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"prj", "--version"

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"prj", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "output.log", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
