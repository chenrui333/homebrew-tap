class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "7999d0d681b4d72a2a47e8260a37e332eb819a0abca4b6569f4913027eb12f03"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89b355664ac3987e95bc1c94111422745d655252516d0342fe71baec8b950205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89b355664ac3987e95bc1c94111422745d655252516d0342fe71baec8b950205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b355664ac3987e95bc1c94111422745d655252516d0342fe71baec8b950205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3559eec64784b52736bae452bf9d57ea9fc7691ea6183e5e9d00bef516b7e55"
    sha256 cellar: :any,                 x86_64_linux:  "07243e4d95284c1d4296f5119772f01423748bbdccc7f710c9eeca8033209bc7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rezmoss/sbomlyze/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/sbomlyze"
  end

  test do
    (testpath/"empty.json").write("{}")

    assert_match version.to_s, shell_output("#{bin}/sbomlyze --version")
    output = shell_output("#{bin}/sbomlyze #{testpath}/empty.json --no-pager")
    assert_match "SBOM Statistics", output
  end
end
