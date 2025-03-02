class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "f0505b6862cf3f7ffb2883b3184bcc15195c6f3df9c50137345715c64d7644d3"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95a30247ee95bf200b128692a1c31eb3ab7bc4568ac2a3afc2f71019a7683e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b81b9312c12571b75b06f2a816fe7ad9c3b18a71edce5e79103fbdf1c319eb"
    sha256 cellar: :any_skip_relocation, ventura:       "9e80e93181301f29cf7c48da9c40b5b61bac0b81aacc299fbd43866648561139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9bf60c18e10199313c0efe6d924eaa83a47b8a6cf00130de4697e25e58d40f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
