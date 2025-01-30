class Koji < Formula
  desc "Interactive CLI for creating conventional commits"
  homepage "https://github.com/cococonscious/koji"
  url "https://github.com/cococonscious/koji/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "648b9d47de121895a79e3d963f5fc6e781d82a1531eeec6b3aa91db5951e058a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "7e7ba7c5ce312902c0f979f19a839facd176a48d948e8147b42ea1a6e4836aed"
    sha256 cellar: :any,                 arm64_sonoma:  "ba38e5032f24ce160ba1279cb35685ce4f6ee493b7fe33b8151af8d4d8ced537"
    sha256 cellar: :any,                 ventura:       "11b0c6b81f67cb8ee3d675e6a83d56403c7ba2cf55708df6d503c4e7b828336c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d045e74d175e1d922d4e6cb2c448475ac087aa305ff0c19fe4296897a2c9d4a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"koji", "completions")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/koji --version")

    require "pty"
    ENV["TERM"] = "xterm"

    # setup git
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"

    # commit with koji
    # $ /opt/homebrew/Cellar/koji/3.2.0/bin/koji
    # > What type of change are you committing? feat
    # > What's the scope of this change? test
    # > Write a short, imperative tense description of the change: test
    # > Provide a longer description of the change: test
    # > Are there any breaking changes? No
    # > Does this change affect any open issues? No
    PTY.spawn(bin/"koji") do |r, w, _pid|
      w.puts "feat"
      w.puts "test"
      w.puts "test"
      w.puts "test"
      w.puts "No"
      w.puts "No"
      begin
        output = r.read
        assert_match "Does this change affect any open issues", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"koji", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
