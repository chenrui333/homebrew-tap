class Tftargets < Formula
  desc "Analyze Terraform configs to find directories affected by Git changes"
  homepage "https://github.com/takaishi/tftargets"
  url "https://github.com/takaishi/tftargets/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "a6c49e50bdbad74319ca01e2938a7ce3cd6294039b7bca7c4c7f3b7db6a7ed68"
  license "MIT"
  head "https://github.com/takaishi/tftargets.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf0c4fff77b10fdbf57c817cbdcde2b219e0e98b7a4d261180711434a658f8ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0c4fff77b10fdbf57c817cbdcde2b219e0e98b7a4d261180711434a658f8ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe9986c38d1e73009ffbd4973d608b67dcbff51841609b88900a04039c4d3de"
    sha256 cellar: :any,                 x86_64_linux:  "75415420e9e9e97d097d87d5e1ac54ff3c1ae4fdc2fc029f10154818d66f1434"
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
