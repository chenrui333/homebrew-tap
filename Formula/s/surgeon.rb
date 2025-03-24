# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "95ac8ef71cd576a60669df2ba35d5cd7bfc426d26553023e869d0834aa5b6ea7"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a04f4e7fb3b76d2c019c27ab5ebfe2a932198f16b0fa02066741d00df8ef950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "204f6186f9a32128dbdb3bf987aa45e753d169ab7e0c5ba41dd8299929d43149"
    sha256 cellar: :any_skip_relocation, ventura:       "55f36b7f3f2035854aeb0e348f9ff3b50ed3fe8fb0c383852a6098da209fe2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14d0ebbfeff3c0bcf314c03ceb205cbb2506ffcf0313d4fab5bb8b458e92862"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bketelsen/surgeon/cmd.version=#{version}
      -X github.com/bketelsen/surgeon/cmd.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"surgeon", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surgeon --version")

    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
