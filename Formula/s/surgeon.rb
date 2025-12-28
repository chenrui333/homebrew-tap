# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "d769bbb4640965c14eb00952f337d65f39c62886920d2171cc8b168abe4da9fd"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7abe26e52a22ef3d0798513583760efaa4d9547944b1ab818fe3f4d21dca9ea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7abe26e52a22ef3d0798513583760efaa4d9547944b1ab818fe3f4d21dca9ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7abe26e52a22ef3d0798513583760efaa4d9547944b1ab818fe3f4d21dca9ea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452d16c69ad8d04217f4ebdace4463fcbb989f2510eec822f99c48861541c610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a366136ceb70534acea2019413a350893a701901002962568236eea78d60f4a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.treeState=clean
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/surgeon"

    generate_completions_from_executable(bin/"surgeon", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surgeon --version")

    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
