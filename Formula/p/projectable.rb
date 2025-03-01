class Projectable < Formula
  desc "TUI file manager built for projects"
  homepage "https://dzfrias.dev/blog/projectable"
  url "https://github.com/dzfrias/projectable/archive/refs/tags/1.3.2.tar.gz"
  sha256 "8677aa186b50e28ae1addaa9178b65de9e07b3fcd54056fd92464b49c9f71312"
  license "MIT"
  head "https://github.com/dzfrias/projectable.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "87abbe736e8eb659f23106320031ac62c99d52cd4503704533d10a34df9e53b3"
    sha256 cellar: :any,                 arm64_sonoma:  "a1900dc08da1b6e06064649b1bd70c859c82f7ca72a96f991e3823646caab4e1"
    sha256 cellar: :any,                 ventura:       "3a0dc21c30496092425cb791e3512d7de24879287d7232aec4b790c750a4d07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb6306f8d78cf9d7728266c472ac15588a74a6b7e619a58cbbdcd715c27d9acb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

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

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"prj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
