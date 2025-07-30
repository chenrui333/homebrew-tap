class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "2d28fd4079b807d5619f9a748860fc81329dc65470785dc274dc4543e58af7f2"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d9c8cc2a88cb727efedf8ace07149df7da732ab9ee07723350f15c262dfae3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de88f0cad3a8bdd7f67224b957ba5fa39cf4842cd79f56dd35e315a232693080"
    sha256 cellar: :any_skip_relocation, ventura:       "efcf0ba64ab39633c5d84534f45dda16a027f3dd658688c21daaea6b551016d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44cf45295c6b99bd8bb962fd6d691fee1e726de38e3aa90bf47ea022c0fde84"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
