class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "eb17caf99dc8becbb2458036b022d95bd4a2eecc57618e246f044ff404884ffb"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff27a4bfc117cc6494753935f2e28429eab44ee2c2a3fcebae291080377f43e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dff27a4bfc117cc6494753935f2e28429eab44ee2c2a3fcebae291080377f43e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dff27a4bfc117cc6494753935f2e28429eab44ee2c2a3fcebae291080377f43e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a96144204166b8c1ab75b1191e7a329cbe84f2130aae6ac7bf3219607334ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb061940b4287dcb7231da3dc3378e08e5a975481eb6db3323f7cb185e3501e"
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
