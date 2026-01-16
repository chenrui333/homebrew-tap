class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "eb17caf99dc8becbb2458036b022d95bd4a2eecc57618e246f044ff404884ffb"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e8edcd4c7d44e2f8855cdb6b4f4ba2111b279b3fcb98e5bb38c8470074ccfb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8edcd4c7d44e2f8855cdb6b4f4ba2111b279b3fcb98e5bb38c8470074ccfb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8edcd4c7d44e2f8855cdb6b4f4ba2111b279b3fcb98e5bb38c8470074ccfb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e465250dad9e35bd9387fabe99c0e33274a2d2ca78ef582ce15db3c11a40645d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "384d992355db87c73f09f961572667730280b8879e35fc13429e50a77452f8f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end
