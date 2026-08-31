class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d9d3825979a496031ba36e49ba739e4cd32abf1e6683f2109e8eb2dbd8215acb"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e0c95e986e5de7b6ceedb672e65bb5d6ee183bd358c27682e28b67f4ff06102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e85fc76583cb26df5cb2cca20dba7a776422d5729dc1c1933318a83d262fbdc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41990bbc9147b0ffbb39175c95a879cc7b4135868b8f81ca9a43c6edf54a70d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6de61221cb304b65b540b0d5d1c081320197b5dc02c50d8db79c215ff71b98dd"
    sha256 cellar: :any,                 x86_64_linux:  "ea9e30a69ceeedd9ec5bdb1c9a6aa91ea4c28a092a0b3445b40960159abaa4cc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/v2/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/v2/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/v2/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/v2/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
