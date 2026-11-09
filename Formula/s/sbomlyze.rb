class Sbomlyze < Formula
  desc "SBOM diff and analysis tool for software supply-chain security"
  homepage "https://rezmoss.github.io/sbomlyze/"
  url "https://github.com/rezmoss/sbomlyze/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b262d01e3c2718d6964c66675725cd037b9e9b401fff855e4535813ac56a90b6"
  license "Apache-2.0"
  head "https://github.com/rezmoss/sbomlyze.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce3e1217ea10167d6a4d4c6c5c3f9cbdfe8cbbbd328ddf0667574988c0a0a487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3e1217ea10167d6a4d4c6c5c3f9cbdfe8cbbbd328ddf0667574988c0a0a487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "691b211cb19c0e39912c38611e1501cc1fc777d9596cd07bf090283d86e79a68"
    sha256 cellar: :any,                 x86_64_linux:  "0ef56bc2236f4dc74b02f3115633c4d39bea94bea237a26755b74bcb4832fd7a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
