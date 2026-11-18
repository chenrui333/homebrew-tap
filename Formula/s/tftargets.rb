class Tftargets < Formula
  desc "Analyze Terraform configs to find directories affected by Git changes"
  homepage "https://github.com/takaishi/tftargets"
  url "https://github.com/takaishi/tftargets/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "c7238483fd72bbfb760ffa72ca496500717abd323cc8c74af59cb429bf29f4d4"
  license "MIT"
  head "https://github.com/takaishi/tftargets.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "170c9eb0758f565433ef4c42dd219767394aec8065654e07fe35ef56c034a905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "170c9eb0758f565433ef4c42dd219767394aec8065654e07fe35ef56c034a905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca99a2beb84b9122b5390d2382057a847a4f04337274b9eeee47dde9deaa522"
    sha256 cellar: :any,                 x86_64_linux:  "dc4991ddbcc8905a7677a679244d702b93c202ac2bceb818898c6f160183f061"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/takaishi/tftargets/cmd/tftargets.Version=#{version}
      -X github.com/takaishi/tftargets/cmd/tftargets.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tftargets"
  end

  test do
    system bin/"tftargets", "--version"
  end
end
