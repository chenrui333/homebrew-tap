class Oyui < Formula
  desc "Terminal merge editor for Git and Jujutsu"
  homepage "https://github.com/emilien-jegou/oyui"
  url "https://github.com/emilien-jegou/oyui/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "19250fe9c858d85051f4dee6c7279188e7298ca64cda5f91bdf8d48e48a618ed"
  license "GPL-3.0-only"
  head "https://github.com/emilien-jegou/oyui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "598de9ec2df2908db229cb5233ece7d5aaefd8e5e64184649b9975bb925c86c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5119da54e31067102f2eec4f9384b87628135e21e01402f7607c02c9ecb21422"
    sha256 cellar: :any,                 arm64_linux:   "f76dbc2dad9ceb47d04c088922ab5b49e31f1baa66e55521b8871b3ef6b1f16c"
    sha256 cellar: :any,                 x86_64_linux:  "77cf7349521404b6e15edf14f2eb737cab80688f0e321c5b001cc10691576d4b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # The 0.2.1 release retains the 0.2.0 Cargo package version.
    inreplace "crates/oyui/src/cli.rs", "version, about", "version = \"#{version}\", about"
    system "cargo", "install", *std_cargo_args(path: "crates/oyui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oyui --version")
    assert_match "unrecognized subcommand", shell_output("#{bin}/oyui invalid-command 2>&1", 2)
  end
end
