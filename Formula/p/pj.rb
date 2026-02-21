class Pj < Formula
  desc "Fast project directory finder"
  homepage "https://github.com/josephschmitt/pj"
  url "https://github.com/josephschmitt/pj/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "0e860c72842f2127e469c3826de8ea9ee04defbc54996060acd8571206f42413"
  license "MIT"
  head "https://github.com/josephschmitt/pj.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea8dee351b19590a602f8a0e080349fa82373045bf564711b949f845d871c81c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea8dee351b19590a602f8a0e080349fa82373045bf564711b949f845d871c81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea8dee351b19590a602f8a0e080349fa82373045bf564711b949f845d871c81c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb6981ed7576f1f51d0530af9c82ad30f5595cb086aae68ca1b075c9e8c33a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5742e5a212c8ca102f954c49e8afabc689b1dc4b87d6dfaff3542641648a5403"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"demo").mkpath
    (testpath/"demo/go.mod").write <<~EOS
      module example.com/demo

      go 1.22
    EOS

    output = shell_output(
      "#{bin}/pj --path #{testpath} --marker go.mod --max-depth 2 --no-cache --format %P",
    )
    assert_equal "#{testpath}/demo\n", output
    assert_match version.to_s, shell_output("#{bin}/pj --version")
  end
end
