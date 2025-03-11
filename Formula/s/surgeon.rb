# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4d4d81e82d5dc3373603c422e7209ec37821a5c00846b3d86526fe88a2d7ad6d"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969b197d92f7485ebe8cb89e6901a48e22a22d750a204454a4283b4ea1f7a565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d57ba355ce03c417952f021c5a22580d7f523efefb7f40369d903816cb3c73"
    sha256 cellar: :any_skip_relocation, ventura:       "195a9c5ba8650b6eed2917243d7d62632b07fc42edca4fe1b2a49576d7cc6fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca5b0ae2b64c46c233f33d56ca11ec3d78329d5ac700f6aefe88a4695c649d8"
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
