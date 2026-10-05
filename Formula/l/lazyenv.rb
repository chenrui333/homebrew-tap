class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e59eca8832e9dec1e5f265efb54424612732aa1f8071daec459bb752fd235a2e"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0fb623fa2975021670b94070fbf3010eb2e88314948185e93a62dc2d59524af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0fb623fa2975021670b94070fbf3010eb2e88314948185e93a62dc2d59524af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607654f6c8dd55364ff573e934fe17f6515827549bd06066e3a77052f9cefe39"
    sha256 cellar: :any,                 x86_64_linux:  "b7befd15d8a12ed07fda4073cc468a4b64e3270db7e9470f739deb48b3ef7341"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyenv --version 2>&1")
  end
end
