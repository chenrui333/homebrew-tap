class Fabrika < Formula
  desc "Software factory that orchestrates CLI coding agents as a managed team"
  homepage "https://fabrika-ai.com"
  url "https://github.com/berkaycubuk/fabrika/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "68e745625269ff3ed5d1b9806893432a7f0665a963d7305af07bef41b19b18bb"
  license "FSL-1.1-MIT"
  head "https://github.com/berkaycubuk/fabrika.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d380af957cab78c73101bdb93c365cbf7faee1210ccfb1b46cc89b1e8527890c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d380af957cab78c73101bdb93c365cbf7faee1210ccfb1b46cc89b1e8527890c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d380af957cab78c73101bdb93c365cbf7faee1210ccfb1b46cc89b1e8527890c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47b058513757b7215fe8d296fba6c3bc207d00137389113e4205c6d437b6edc"
    sha256 cellar: :any,                 x86_64_linux:  "545296a3d021dc53a00cfd297ffdd2dd68edc3129bfbc148fdcf99a882c74d79"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fabrika"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabrika version")
    output = shell_output("#{bin}/fabrika not-a-real-command 2>&1", 1)
    assert_match "no fabrika.toml", output
  end
end
