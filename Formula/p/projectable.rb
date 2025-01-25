class Projectable < Formula
  desc "TUI file manager built for projects"
  homepage "https://dzfrias.dev/blog/projectable"
  url "https://github.com/dzfrias/projectable/archive/refs/tags/1.3.0.tar.gz"
  sha256 "fe1c0edf9f14f2cd9cfef7e9af921f3e4b307b5c518a7b79f96563d6269a1e72"
  license "MIT"
  head "https://github.com/dzfrias/projectable.git", branch: "main"

  bottle do
    root_url "https://github.com/chenrui333/homebrew-tap/releases/download/projectable-1.3.0"
    sha256 cellar: :any,                 arm64_sequoia: "6e414bd1b64dcee555169a517a81d10c03647751ef38494ebc1d793a556c5789"
    sha256 cellar: :any,                 arm64_sonoma:  "386962093ccc0171bd80c611bdafd8a853a8459d7a8f3bfdefa2bb0602b4f855"
    sha256 cellar: :any,                 ventura:       "b1c41e0b8c894ac21a89e022d1d1bef623a8651a004fe3b7d6a863d0a286cd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766553bfb69df3f669521bdcde28b0fdd3171801cd5356e119fe30c277303824"
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
