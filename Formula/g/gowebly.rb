class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "1fb7c5ffc04ece4478c6579ccde4f7df82aeccab96e59cd2330fb223627a84a5"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b882266f7b35d610cfdbf65a64a11703268fe783ebb4bebf46b3a78dfb37fdc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66099b4a282436e75d62f360aa9591a7d518dc5a46b610f08c96857f643b1f92"
    sha256 cellar: :any_skip_relocation, ventura:       "932d9106da60ab17b4761ac02d0d33669928555d7ef3df89450b5a41c4ee0639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62384eb932e734615af24d2b01ae12aaaf4eb2adfe28b7d40e6a3084ee1011ed"
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
