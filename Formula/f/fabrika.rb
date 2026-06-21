class Fabrika < Formula
  desc "Software factory that orchestrates CLI coding agents as a managed team"
  homepage "https://fabrika-ai.com"
  url "https://github.com/berkaycubuk/fabrika/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "78851e03368074497954e61e0a7c84114b4e23efe3837f5c019f59ba2823de0a"
  license "FSL-1.1-MIT"
  head "https://github.com/berkaycubuk/fabrika.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d097f2c3e0447627c3279aed346267ab50869be85aa071c9454e1357bb87fa5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d097f2c3e0447627c3279aed346267ab50869be85aa071c9454e1357bb87fa5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d097f2c3e0447627c3279aed346267ab50869be85aa071c9454e1357bb87fa5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0c10ea02bbd69d9782e57fc4d23bb4f21cd4606a61bb7ffc82f0117ee8170a5"
    sha256 cellar: :any,                 x86_64_linux:  "6b60136c2b149a64eda12d9c7ced310f53f2b1253b9ac7c8565f4c5acf8cddb9"
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
