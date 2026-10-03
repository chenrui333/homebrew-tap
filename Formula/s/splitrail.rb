class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.10.3.tar.gz"
  sha256 "21aee0453d020ac8e9840b064b3c048247b70c8f9b12243c931bb408b80d33e4"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc341a8d5a01d3bd6e8f358c5c3908b1bbe86ef7fb8bda9bc1b0fa3a9197573b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2fd42511533eb776961e3ba1847196f658f8979f44444b86416963e6f072098"
    sha256 cellar: :any,                 arm64_linux:   "dbdf186b16b53b0523a176f67157acf3f2ae56967e9d1739aa51d132f99f6923"
    sha256 cellar: :any,                 x86_64_linux:  "0f48eb210e454915ac765f7fd21c119c8895a2196dd47bb2c28f98e71ee8b3c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
