class Pj < Formula
  desc "Fast project directory finder"
  homepage "https://github.com/josephschmitt/pj"
  url "https://github.com/josephschmitt/pj/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7c08277c6cae5c5193400c2fbe2f2b87a68c79502278e088285ec45abe2b1bd5"
  license "MIT"
  head "https://github.com/josephschmitt/pj.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4643a8108a5466016e939fb668104ac2d6f5baad199b172f25de49a13a233040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4643a8108a5466016e939fb668104ac2d6f5baad199b172f25de49a13a233040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4643a8108a5466016e939fb668104ac2d6f5baad199b172f25de49a13a233040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ad00ce01ece0ed0913ce03f63c3bb020a26a50fd8dfee95a6f1a5156ec5f5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9801ba6d0bf4bee70e46caca5b848032a14e9018b1058a439ffa0896ad742720"
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
