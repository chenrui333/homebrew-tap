class Rslocal < Formula
  desc "Tunnel to localhost built in Rust"
  homepage "https://github.com/bonaysoft/rslocal"
  url "https://static.crates.io/crates/rslocal/rslocal-0.1.0.crate"
  sha256 "77b0b968939cbb94dbfbcfc227e65836883651de12221c6ed8d119e970f6a1b4"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac01b391e2266a90fce4c88e08cdceb1834462a115955e007490ccb3986d94ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a6ecfc0dc9a2dd6fc18c7bb020d4517ea3fd3f1d5e74f1d3027ec4f4bc6ee2"
    sha256 cellar: :any,                 arm64_linux:   "0a39d79106c6f4580b14b55ad90a9ee02097c770d3830c5a45c7b7bf4b01e0df"
    sha256 cellar: :any,                 x86_64_linux:  "10d7b23adcdc671f720bcc9bf1c7ee2e159506d55ec02078ad766bedd75a71ee"
  end

  depends_on "protobuf" => :build # for prost-build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Without a config file the client fails before contacting any tunnel server.
    output = shell_output("#{bin}/rslocal http 8000 2>&1", 1)
    assert_match %r{configuration file ".*/rslocal/config\.ini" not found}, output

    assert_match version.to_s, shell_output("#{bin}/rslocal --version")
    assert_match version.to_s, shell_output("#{bin}/rslocald --version")
  end
end
