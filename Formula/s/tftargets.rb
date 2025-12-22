class Tftargets < Formula
  desc "Analyze Terraform configs to find directories affected by Git changes"
  homepage "https://github.com/takaishi/tftargets"
  url "https://github.com/takaishi/tftargets/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "a6c49e50bdbad74319ca01e2938a7ce3cd6294039b7bca7c4c7f3b7db6a7ed68"
  license "MIT"
  head "https://github.com/takaishi/tftargets.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c687c539aa83cec0bbb30f31d4dcf479abbf1704fe79a9c418497b5225c1df14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c687c539aa83cec0bbb30f31d4dcf479abbf1704fe79a9c418497b5225c1df14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c687c539aa83cec0bbb30f31d4dcf479abbf1704fe79a9c418497b5225c1df14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41c1c711e201e66fad1fd58e75bb312545ba95cefccfa366a73d60f3653e1933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0605e619eaa853280dc572ba740ce0a9edf7ad00eaf40955cbcd73b72884635"
  end

  depends_on "go" => :build

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
