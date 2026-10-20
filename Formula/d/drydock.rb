class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "78340eccd8a2c2d332a61fa5f35ff9494eb0404e363b8740f665f5e42e87a8c5"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cb434565a94be2bb8812d0f8000f02fbd9db15554657cb29b73495e3fc2e953"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6073d279e39427c021aa5e0edabbb18c6e3e89e23904a3df53f62ec727cffc8"
    sha256 cellar: :any,                 arm64_linux:   "0e0246cf1c47175961a615b0139d9ff73d8ef051135bc0298803fe90cab9cf47"
    sha256 cellar: :any,                 x86_64_linux:  "d58a6717202b3cb56eb01a9eec5deaa7e87ebfd008bce0ab9f6f67cbfb7c6c32"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")
    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
