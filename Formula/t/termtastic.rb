class Termtastic < Formula
  desc "Meshtastic console client"
  homepage "https://github.com/acelot/termtastic"
  url "https://github.com/acelot/termtastic/archive/refs/tags/v1.0.0-alpha7.tar.gz"
  sha256 "b1d852b1f219b81ca1f7e7a083b7b0ef461e37fadf1adce3f93789ec15b9e078"
  license "GPL-3.0-only"
  head "https://github.com/acelot/termtastic.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a70380c06886a2a9d9b48b2d2825297a6e015e164ff1ad56cafcc195eafc1d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7455241d4ae0bdb19a882b6e8a1e31c879e98871e399845b548dd2a3ed726ee"
    sha256 cellar: :any,                 arm64_linux:   "aef95d740f8b9c57fb4c51f4e439457a8a3bf8b1cf0172a66e287fb5fccbd73d"
    sha256 cellar: :any,                 x86_64_linux:  "24d8276ef0a4f618ea8f1232e0bcbfcdcc636290f7aa9936bd2e26f05b96d978"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["GIT_REF_TYPE"] = "tag"
    ENV["GIT_REF_NAME"] = "v#{version}"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termtastic --version")

    # Fail before radio discovery by making the application data directory unwritable.
    (testpath/"blocked").write "not a directory"
    output = shell_output("XDG_DATA_HOME=#{testpath}/blocked #{bin}/termtastic 2>&1", 101)
    assert_match "initializing rolling file appender failed", output
  end
end
