class Hyperbolic < Formula
  desc "Command-line interface for creating and managing GPU instances on Hyperbolic"
  homepage "https://github.com/HyperbolicLabs/hyperbolic-cli"
  url "https://github.com/HyperbolicLabs/hyperbolic-cli/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "c6c88cbd0f48d67df9688a50b59b13fc3bd6b24cd4274e142f63d7fd1d8b7928"
  license "MIT"
  head "https://github.com/HyperbolicLabs/hyperbolic-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04c76c43eeaed269a0b8715077e4a17f4a4873c7758763cff6403c96c12e6c0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c76c43eeaed269a0b8715077e4a17f4a4873c7758763cff6403c96c12e6c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c76c43eeaed269a0b8715077e4a17f4a4873c7758763cff6403c96c12e6c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c9aa18c61dc4cf8af1f2524f624212ee5717303411aae53630151502999714"
    sha256 cellar: :any,                 x86_64_linux:  "4702ccb31be0b65b33e8c14ed14ef30579f11fa8a5d15e275923bc2563b0c118"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"hyperbolic", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
